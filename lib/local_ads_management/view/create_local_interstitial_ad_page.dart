import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/create_local_ads/create_local_interstitial_ad_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template create_local_interstitial_ad_page}
/// A page for creating a new local interstitial ad.
/// It uses a [BlocProvider] to create and provide a [CreateLocalInterstitialAdBloc].
/// {@endtemplate}
class CreateLocalInterstitialAdPage extends StatelessWidget {
  /// {@macro create_local_interstitial_ad_page}
  const CreateLocalInterstitialAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateLocalInterstitialAdBloc(
        localAdsRepository: context.read<DataRepository<LocalAd>>(),
      ),
      child: const _CreateLocalInterstitialAdView(),
    );
  }
}

class _CreateLocalInterstitialAdView extends StatefulWidget {
  const _CreateLocalInterstitialAdView();

  @override
  State<_CreateLocalInterstitialAdView> createState() =>
      _CreateLocalInterstitialAdViewState();
}

class _CreateLocalInterstitialAdViewState
    extends State<_CreateLocalInterstitialAdView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _imageUrlController;
  late final TextEditingController _targetUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateLocalInterstitialAdBloc>().state;
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
        title: Text(l10n.createLocalInterstitialAdTitle),
        actions: [
          BlocBuilder<
            CreateLocalInterstitialAdBloc,
            CreateLocalInterstitialAdState
          >(
            builder: (context, state) {
              if (state.status == CreateLocalInterstitialAdStatus.submitting) {
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
                    ? () => context.read<CreateLocalInterstitialAdBloc>().add(
                        const CreateLocalInterstitialAdSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body:
          BlocConsumer<
            CreateLocalInterstitialAdBloc,
            CreateLocalInterstitialAdState
          >(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == CreateLocalInterstitialAdStatus.success &&
                  state.createdLocalInterstitialAd != null &&
                  ModalRoute.of(context)!.isCurrent) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.localInterstitialAdCreatedSuccessfully,
                      ),
                    ),
                  );
                context.pop();
              }
              if (state.status == CreateLocalInterstitialAdStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        state.exception!.toFriendlyMessage(context),
                      ),
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
                          onChanged: (value) =>
                              context.read<CreateLocalInterstitialAdBloc>().add(
                                CreateLocalInterstitialAdImageUrlChanged(value),
                              ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: _targetUrlController,
                          decoration: InputDecoration(
                            labelText: l10n.targetUrl,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) =>
                              context.read<CreateLocalInterstitialAdBloc>().add(
                                CreateLocalInterstitialAdTargetUrlChanged(
                                  value,
                                ),
                              ),
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
