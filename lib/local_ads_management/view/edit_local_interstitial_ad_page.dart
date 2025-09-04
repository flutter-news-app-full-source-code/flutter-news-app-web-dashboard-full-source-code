import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/update_local_ads/update_local_interstitial_ad_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/content_status_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template edit_local_interstitial_ad_page}
/// A page for editing an existing local interstitial ad.
/// It uses a [BlocProvider] to create and provide an [UpdateLocalInterstitialAdBloc].
/// {@endtemplate}
class EditLocalInterstitialAdPage extends StatelessWidget {
  /// {@macro edit_local_interstitial_ad_page}
  const EditLocalInterstitialAdPage({
    required this.adId,
    super.key,
  });

  /// The ID of the local interstitial ad to be edited.
  final String adId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateLocalInterstitialAdBloc(
        localAdsRepository: context.read<DataRepository<LocalAd>>(),
        id: adId,
      ),
      child: _EditLocalInterstitialAdView(adId: adId),
    );
  }
}

class _EditLocalInterstitialAdView extends StatefulWidget {
  const _EditLocalInterstitialAdView({required this.adId});

  final String adId;

  @override
  State<_EditLocalInterstitialAdView> createState() =>
      _EditLocalInterstitialAdViewState();
}

class _EditLocalInterstitialAdViewState
    extends State<_EditLocalInterstitialAdView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _imageUrlController;
  late final TextEditingController _targetUrlController;

  @override
  void initState() {
    super.initState();
    _imageUrlController = TextEditingController();
    _targetUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _targetUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editLocalInterstitialAdTitle),
        actions: [
          BlocBuilder<UpdateLocalInterstitialAdBloc,
              UpdateLocalInterstitialAdState>(
            builder: (context, state) {
              if (state.status == UpdateLocalInterstitialAdStatus.submitting) {
                return const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.lg),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.saveChanges,
                onPressed: state.isFormValid && state.isDirty
                    ? () => context.read<UpdateLocalInterstitialAdBloc>().add(
                          const UpdateLocalInterstitialAdSubmitted(),
                        )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<UpdateLocalInterstitialAdBloc,
          UpdateLocalInterstitialAdState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == UpdateLocalInterstitialAdStatus.success &&
              state.updatedAd != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.localInterstitialAdUpdatedSuccessfully),
                ),
              );
            context.pop();
          }
          if (state.status == UpdateLocalInterstitialAdStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception!.toFriendlyMessage(context)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
          // Update text controllers when data is loaded or changed
          if (state.status == UpdateLocalInterstitialAdStatus.initial &&
              state.initialAd != null) {
            _imageUrlController.text = state.imageUrl;
            _targetUrlController.text = state.targetUrl;
          }
        },
        builder: (context, state) {
          if (state.status == UpdateLocalInterstitialAdStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.ads_click,
              headline: l10n.loadingLocalAd,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == UpdateLocalInterstitialAdStatus.failure &&
              state.initialAd == null) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<UpdateLocalInterstitialAdBloc>().add(
                    UpdateLocalInterstitialAdLoaded(widget.adId),
                  ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.imageUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<UpdateLocalInterstitialAdBloc>()
                          .add(UpdateLocalInterstitialAdImageUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _targetUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.targetUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<UpdateLocalInterstitialAdBloc>()
                          .add(UpdateLocalInterstitialAdTargetUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SearchableSelectionInput<ContentStatus>(
                      label: l10n.status,
                      selectedItem: state.contentStatus,
                      staticItems: ContentStatus.values.toList(),
                      itemBuilder: (context, status) =>
                          Text(status.l10n(context)),
                      itemToString: (status) => status.l10n(context),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<UpdateLocalInterstitialAdBloc>().add(
                              UpdateLocalInterstitialAdStatusChanged(value),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
