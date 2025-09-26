import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/create_local_ads/create_local_native_ad_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template create_local_native_ad_page}
/// A page for creating a new local native ad.
/// It uses a [BlocProvider] to create and provide a [CreateLocalNativeAdBloc].
/// {@endtemplate}
class CreateLocalNativeAdPage extends StatelessWidget {
  /// {@macro create_local_native_ad_page}
  const CreateLocalNativeAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateLocalNativeAdBloc(
        localAdsRepository: context.read<DataRepository<LocalAd>>(),
      ),
      child: const _CreateLocalNativeAdView(),
    );
  }
}

class _CreateLocalNativeAdView extends StatefulWidget {
  const _CreateLocalNativeAdView();

  @override
  State<_CreateLocalNativeAdView> createState() =>
      _CreateLocalNativeAdViewState();
}

class _CreateLocalNativeAdViewState extends State<_CreateLocalNativeAdView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _targetUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateLocalNativeAdBloc>().state;
    _titleController = TextEditingController(text: state.title);
    _subtitleController = TextEditingController(text: state.subtitle);
    _imageUrlController = TextEditingController(text: state.imageUrl);
    _targetUrlController = TextEditingController(text: state.targetUrl);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _imageUrlController.dispose();
    _targetUrlController.dispose();
    super.dispose();
  }

  /// Shows a dialog to the user to choose between publishing or saving as draft.
  Future<ContentStatus?> _showSaveOptionsDialog(BuildContext context) async {
    final l10n = AppLocalizationsX(context).l10n;
    return showDialog<ContentStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.saveAdTitle),
        content: Text(l10n.saveAdMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(ContentStatus.draft),
            child: Text(l10n.saveAsDraft),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ContentStatus.active),
            child: Text(l10n.publish),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createLocalNativeAdTitle),
        actions: [
          BlocBuilder<CreateLocalNativeAdBloc, CreateLocalNativeAdState>(
            builder: (context, state) {
              if (state.status == CreateLocalNativeAdStatus.submitting) {
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
                onPressed: state.isFormValid
                    ? () async {
                        final selectedStatus = await _showSaveOptionsDialog(
                          context,
                        );
                        if (selectedStatus == ContentStatus.active &&
                            context.mounted) {
                          context.read<CreateLocalNativeAdBloc>().add(
                            const CreateLocalNativeAdPublished(),
                          );
                        } else if (selectedStatus == ContentStatus.draft &&
                            context.mounted) {
                          context.read<CreateLocalNativeAdBloc>().add(
                            const CreateLocalNativeAdSavedAsDraft(),
                          );
                        }
                      }
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateLocalNativeAdBloc, CreateLocalNativeAdState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateLocalNativeAdStatus.success &&
              state.createdLocalNativeAd != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.localNativeAdCreatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == CreateLocalNativeAdStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception!.toFriendlyMessage(context)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
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
                          .read<CreateLocalNativeAdBloc>()
                          .add(CreateLocalNativeAdTitleChanged(value)),
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
                          .read<CreateLocalNativeAdBloc>()
                          .add(CreateLocalNativeAdSubtitleChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.imageUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateLocalNativeAdBloc>()
                          .add(CreateLocalNativeAdImageUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _targetUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.targetUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateLocalNativeAdBloc>()
                          .add(CreateLocalNativeAdTargetUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
