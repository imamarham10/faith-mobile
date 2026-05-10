import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/dhikr_phrase.dart';
import '../controllers/dhikr_counters_controller.dart';
import '../widgets/dictionary_picker.dart';

/// Bottom sheet for creating a new dhikr counter.
///
/// Two paths: pick a dictionary phrase, or fall through to the "Custom"
/// section to type a name and target. Returns a [DhikrPhrase] to the
/// caller (the home screen creates the counter and navigates).
class NewCounterSheet extends ConsumerStatefulWidget {
  const NewCounterSheet({super.key});

  @override
  ConsumerState<NewCounterSheet> createState() => _NewCounterSheetState();
}

class _NewCounterSheetState extends ConsumerState<NewCounterSheet> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController(text: '33');
  final _formKey = GlobalKey<FormState>();
  bool _showCustom = false;

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dictionary =
        ref.watch(dhikrDictionaryProvider).valueOrNull ?? const <DhikrPhrase>[];
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        0,
        AppSpacing.screenEdge,
        AppSpacing.lg + viewInsets,
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(4),
            Text('New counter', style: theme.textTheme.headlineMedium),
            const Gap(4),
            Text(
              'Choose a phrase or create your own.',
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(20),
            if (!_showCustom) ...[
              const SectionLabel('From dictionary'),
              const Gap(12),
              if (dictionary.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Text(
                    'Loading phrases…',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              else
                for (final p in dictionary) ...[
                  DictionaryPicker(
                    phrase: p,
                    onTap: () => Navigator.of(context).pop(p),
                  ),
                  const Gap(8),
                ],
              const Gap(12),
              TextButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() => _showCustom = true);
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Create custom'),
              ),
            ] else
              _CustomForm(
                formKey: _formKey,
                nameController: _nameController,
                targetController: _targetController,
                onCancel: () => setState(() => _showCustom = false),
                onCreate: _submitCustom,
              ),
          ],
        ),
      ),
    );
  }

  void _submitCustom() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final name = _nameController.text.trim();
    final target = int.tryParse(_targetController.text.trim()) ?? 33;
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(
      DhikrPhrase(
        id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
        phraseArabic: '',
        phraseTransliteration: name,
        meaning: '',
        recommendedCount: target,
      ),
    );
  }
}

class _CustomForm extends StatelessWidget {
  const _CustomForm({
    required this.formKey,
    required this.nameController,
    required this.targetController,
    required this.onCancel,
    required this.onCreate,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController targetController;
  final VoidCallback onCancel;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Custom counter'),
          const Gap(12),
          TextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Salawat, Morning adhkar',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Add a name.' : null,
          ),
          const Gap(12),
          TextFormField(
            controller: targetController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Target count',
              hintText: '33',
            ),
            validator: (v) {
              final n = int.tryParse(v?.trim() ?? '');
              if (n == null || n <= 0) return 'Enter a positive number.';
              return null;
            },
            onFieldSubmitted: (_) => onCreate(),
          ),
          const Gap(20),
          Row(
            children: [
              TextButton(onPressed: onCancel, child: const Text('Back')),
              const Spacer(),
              FilledButton(onPressed: onCreate, child: const Text('Create')),
            ],
          ),
        ],
      ),
    );
  }
}
