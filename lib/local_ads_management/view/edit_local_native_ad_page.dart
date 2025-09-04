import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/update_local_ads/update_local_native_ad_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/content_status_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template edit_local_native_ad_page}
/// A page for editing an existing local native ad.
/// It uses a [BlocProvider] to create and provide an [UpdateLocalNativeAdBloc].
/// {@endtemplate}
class EditLocalNativeAdPage extends StatelessWidget {
  /// {@macro edit_local_native_ad_page}
  const EditLocalNativeAdPage({
    required this.adId,
    super.key,
  });

  /// The ID of the local native ad to be edited.
  final String adId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateLocalNativeAdBloc(
        localAdsRepository: context.read<DataRepository<LocalAd>>(),
        id: adId,
      ),
      child: _EditLocalNativeAdView(adId: adId),
    );
  }
}

class _EditLocalNativeAdView extends StatefulWidget {
  const _EditLocalNativeAdView({required this.adId});

  final String adId;

  @override
  State<_EditLocalNativeAdView> createState() => _EditLocalNativeAdViewState();
}

class _EditLocalNativeAdViewState extends State<_EditLocalNativeAdView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _targetUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    _imageUrlController = TextEditingController();
    _targetUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _imageUrlController.dispose();
    _targetUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editLocalNativeAdTitle),
        actions: [
          BlocBuilder<UpdateLocalNativeAdBloc, UpdateLocalNativeAdState>(
            builder: (context, state) {
              if (state.status == UpdateLocalNativeAdStatus.submitting) {
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
                    ? () => context.read<UpdateLocalNativeAdBloc>().add(
                          const UpdateLocalNativeAdSubmitted(),
                        )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<UpdateLocalNativeAdBloc, UpdateLocalNativeAdState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == UpdateLocalNativeAdStatus.success &&
              state.updatedAd != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.localNativeAdUpdatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == UpdateLocalNativeAdStatus.failure) {
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
          if (state.status == UpdateLocalNativeAdStatus.initial &&
              state.initialAd != null) {
            _titleController.text = state.title;
            _subtitleController.text = state.subtitle;
            _imageUrlController.text = state.imageUrl;
            _targetUrlController.text = state.targetUrl;
          }
        },
        builder: (context, state) {
          if (state.status == UpdateLocalNativeAdStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.ads_click,
              headline: l10n.loadingLocalAd,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == UpdateLocalNativeAdStatus.failure &&
              state.initialAd == null) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<UpdateLocalNativeAdBloc>().add(
                    UpdateLocalNativeAdLoaded(widget.adId),
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
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.adTitle,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<UpdateLocalNativeAdBloc>()
                          .add(UpdateLocalNativeAdTitleChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _subtitleController,
                      decoration: InputDecoration(
                        labelText: l10n.adSubtitle,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => context
                          .read<UpdateLocalNativeAdBloc>()
                          .add(UpdateLocalNativeAdSubtitleChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.imageUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<UpdateLocalNativeAdBloc>()
                          .add(UpdateLocalNativeAdImageUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _targetUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.targetUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<UpdateLocalNativeAdBloc>()
                          .add(UpdateLocalNativeAdTargetUrlChanged(value)),
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
                        context.read<UpdateLocalNativeAdBloc>().add(
                              UpdateLocalNativeAdStatusChanged(value),
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
