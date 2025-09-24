import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/create_local_ads/create_local_video_ad_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template create_local_video_ad_page}
/// A page for creating a new local video ad.
/// It uses a [BlocProvider] to create and provide a [CreateLocalVideoAdBloc].
/// {@endtemplate}
class CreateLocalVideoAdPage extends StatelessWidget {
  /// {@macro create_local_video_ad_page}
  const CreateLocalVideoAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateLocalVideoAdBloc(
        localAdsRepository: context.read<DataRepository<LocalAd>>(),
      ),
      child: const _CreateLocalVideoAdView(),
    );
  }
}

class _CreateLocalVideoAdView extends StatefulWidget {
  const _CreateLocalVideoAdView();

  @override
  State<_CreateLocalVideoAdView> createState() =>
      _CreateLocalVideoAdViewState();
}

class _CreateLocalVideoAdViewState extends State<_CreateLocalVideoAdView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _videoUrlController;
  late final TextEditingController _targetUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateLocalVideoAdBloc>().state;
    _videoUrlController = TextEditingController(text: state.videoUrl);
    _targetUrlController = TextEditingController(text: state.targetUrl);
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
        title: Text(l10n.createLocalVideoAdTitle),
        actions: [
          BlocBuilder<CreateLocalVideoAdBloc, CreateLocalVideoAdState>(
            builder: (context, state) {
              if (state.status == CreateLocalVideoAdStatus.submitting) {
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
                    ? () => context.read<CreateLocalVideoAdBloc>().add(
                        const CreateLocalVideoAdSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateLocalVideoAdBloc, CreateLocalVideoAdState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateLocalVideoAdStatus.success &&
              state.createdLocalVideoAd != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.localVideoAdCreatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == CreateLocalVideoAdStatus.failure) {
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
                      controller: _videoUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.videoUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateLocalVideoAdBloc>()
                          .add(CreateLocalVideoAdVideoUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _targetUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.targetUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateLocalVideoAdBloc>()
                          .add(CreateLocalVideoAdTargetUrlChanged(value)),
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
