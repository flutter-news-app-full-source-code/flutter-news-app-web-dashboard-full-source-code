import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/update_local_ads/update_local_video_ad_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/content_status_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template edit_local_video_ad_page}
/// A page for editing an existing local video ad.
/// It uses a [BlocProvider] to create and provide an [UpdateLocalVideoAdBloc].
/// {@endtemplate}
class EditLocalVideoAdPage extends StatelessWidget {
  /// {@macro edit_local_video_ad_page}
  const EditLocalVideoAdPage({
    required this.adId,
    super.key,
  });

  /// The ID of the local video ad to be edited.
  final String adId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateLocalVideoAdBloc(
        localAdsRepository: context.read<DataRepository<LocalAd>>(),
        id: adId,
      ),
      child: _EditLocalVideoAdView(adId: adId),
    );
  }
}

class _EditLocalVideoAdView extends StatefulWidget {
  const _EditLocalVideoAdView({required this.adId});

  final String adId;

  @override
  State<_EditLocalVideoAdView> createState() => _EditLocalVideoAdViewState();
}

class _EditLocalVideoAdViewState extends State<_EditLocalVideoAdView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _videoUrlController;
  late final TextEditingController _targetUrlController;

  @override
  void initState() {
    super.initState();
    _videoUrlController = TextEditingController();
    _targetUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _videoUrlController.dispose();
    _targetUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editLocalVideoAdTitle),
        actions: [
          BlocBuilder<UpdateLocalVideoAdBloc, UpdateLocalVideoAdState>(
            builder: (context, state) {
              if (state.status == UpdateLocalVideoAdStatus.submitting) {
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
                    ? () => context.read<UpdateLocalVideoAdBloc>().add(
                        const UpdateLocalVideoAdSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<UpdateLocalVideoAdBloc, UpdateLocalVideoAdState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == UpdateLocalVideoAdStatus.success &&
              state.updatedAd != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.localVideoAdUpdatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == UpdateLocalVideoAdStatus.failure) {
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
          if (state.status == UpdateLocalVideoAdStatus.initial &&
              state.initialAd != null) {
            _videoUrlController.text = state.videoUrl;
            _targetUrlController.text = state.targetUrl;
          }
        },
        builder: (context, state) {
          if (state.status == UpdateLocalVideoAdStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.ads_click,
              headline: l10n.loadingLocalAd,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == UpdateLocalVideoAdStatus.failure &&
              state.initialAd == null) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<UpdateLocalVideoAdBloc>().add(
                UpdateLocalVideoAdLoaded(widget.adId),
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
                      controller: _videoUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.videoUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<UpdateLocalVideoAdBloc>()
                          .add(UpdateLocalVideoAdVideoUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _targetUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.targetUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<UpdateLocalVideoAdBloc>()
                          .add(UpdateLocalVideoAdTargetUrlChanged(value)),
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
                        context.read<UpdateLocalVideoAdBloc>().add(
                          UpdateLocalVideoAdStatusChanged(value),
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
