import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/create_local_ads/create_local_banner_ad_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template create_local_banner_ad_page}
/// A page for creating a new local banner ad.
/// It uses a [BlocProvider] to create and provide a [CreateLocalBannerAdBloc].
/// {@endtemplate}
class CreateLocalBannerAdPage extends StatelessWidget {
  /// {@macro create_local_banner_ad_page}
  const CreateLocalBannerAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateLocalBannerAdBloc(
        localAdsRepository: context.read<DataRepository<LocalAd>>(),
      ),
      child: const _CreateLocalBannerAdView(),
    );
  }
}

class _CreateLocalBannerAdView extends StatefulWidget {
  const _CreateLocalBannerAdView();

  @override
  State<_CreateLocalBannerAdView> createState() =>
      _CreateLocalBannerAdViewState();
}

class _CreateLocalBannerAdViewState extends State<_CreateLocalBannerAdView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _imageUrlController;
  late final TextEditingController _targetUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateLocalBannerAdBloc>().state;
    _imageUrlController = TextEditingController(text: state.imageUrl);
    _targetUrlController = TextEditingController(text: state.targetUrl);
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
        title: Text(l10n.createLocalBannerAdTitle),
        actions: [
          BlocBuilder<CreateLocalBannerAdBloc, CreateLocalBannerAdState>(
            builder: (context, state) {
              if (state.status == CreateLocalBannerAdStatus.submitting) {
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
                    ? () => context.read<CreateLocalBannerAdBloc>().add(
                        const CreateLocalBannerAdSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateLocalBannerAdBloc, CreateLocalBannerAdState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateLocalBannerAdStatus.success &&
              state.createdLocalBannerAd != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.localBannerAdCreatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == CreateLocalBannerAdStatus.failure) {
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
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.imageUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateLocalBannerAdBloc>()
                          .add(CreateLocalBannerAdImageUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _targetUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.targetUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateLocalBannerAdBloc>()
                          .add(CreateLocalBannerAdTargetUrlChanged(value)),
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
