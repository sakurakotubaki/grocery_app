---
name: riverpod
description: Guides Riverpod setup, ProviderScope, defining providers (codegen and manual), ref.watch vs ref.read, combining async providers, family parameters, autoDispose and lifecycle, eager init, side effects, ProviderObserver, and testing with overrides. Use when working on Flutter/Dart state management with flutter_riverpod or riverpod_annotation, or when the user mentions providers, Notifier, AsyncValue, or Riverpod tests.
---

# Riverpod

Correct usage patterns for [Riverpod](https://github.com/rrousselGit/riverpod) in Flutter and Dart. Prefer [riverpod_lint](https://pub.dev/packages/riverpod_lint) for refactors and consistency.

## 1. Setup

```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

- Wrap the app with `ProviderScope` directly in `runApp` — not inside `MyApp`.
- Install and enable `riverpod_lint`.

## 2. Defining providers

```dart
// Functional provider (codegen)
@riverpod
int example(Ref ref) => 0;

// FutureProvider (codegen)
@riverpod
Future<List<Todo>> todos(Ref ref) async {
  return ref.watch(repositoryProvider).fetchTodos();
}

// Notifier (codegen)
@riverpod
class TodosNotifier extends _$TodosNotifier {
  @override
  Future<List<Todo>> build() async {
    return ref.watch(repositoryProvider).fetchTodos();
  }

  Future<void> addTodo(Todo todo) async { ... }
}
```

- Define providers as **`final` top-level** (or generated equivalents).
- Choose `Provider`, `FutureProvider`, or `StreamProvider` by return type.
- Use `ConsumerWidget` / `ConsumerStatefulWidget` when reading providers from UI.

## 3. Using `Ref`

| Method | Use for |
|--------|---------|
| `ref.watch` | Reactive listen — rebuilds on change. **Only during build.** |
| `ref.read` | One-shot read — callbacks, Notifier methods, **not** in build. |
| `ref.listen` | Imperative reactions — prefer `ref.watch` when enough. |
| `ref.onDispose` | Cleanup when provider state is destroyed. |

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text('$value');
  }
}

// Cleanup in a provider
final provider = StreamProvider<int>((ref) {
  final controller = StreamController<int>();
  ref.onDispose(controller.close);
  return controller.stream;
});
```

- **Never** call `ref.watch` inside callbacks, listeners, or Notifier methods.
- From UI: `ref.read(yourNotifierProvider.notifier).method()`.
- After `await` in async callbacks, check `context.mounted` before using `context`/`ref` if needed.

## 4. Combining providers

```dart
@riverpod
Future<String> userGreeting(Ref ref) async {
  final user = await ref.watch(userProvider.future);
  return 'Hello, ${user.name}!';
}
```

- `ref.watch(asyncProvider.future)` awaits the async provider’s value.
- Providers cache; multiple listeners share one computation.

## 5. Passing arguments (families)

```dart
@riverpod
Future<Todo> todo(Ref ref, String id) async {
  return ref.watch(repositoryProvider).fetchTodo(id);
}

// Usage
final todo = ref.watch(todoProvider('some-id'));
```

- Enable **`autoDispose`** for parameterized providers to avoid leaks.
- Multiple parameters: Dart 3 **records** or codegen — good `==`.
- Avoid plain `List`/`Map` as keys unless `const` or equality-safe; prefer records or value types.
- Enable `provider_parameters` from `riverpod_lint`.

## 6. Auto dispose and lifecycle

- **Codegen**: state is disposed by default when unused; opt out with `keepAlive: true`.
- **Manual**: state stays alive by default; use `.autoDispose` to dispose when unused.
- Recomputing a provider destroys its previous state.

```dart
ref.onCancel(() {
  final link = ref.keepAlive();
  Timer(const Duration(minutes: 5), link.close);
});
```

- In `ref.onDispose`: cleanup only — no side effects that mutate other providers.
- `ref.invalidate(provider)` forces teardown; `ref.invalidateSelf()` from inside the provider.
- `ref.refresh(provider)` invalidates and returns the new value — **use the return value**.

## 7. Eager initialization

Providers are **lazy**. To warm them early:

```dart
Consumer(
  builder: (context, ref, _) {
    ref.watch(myEagerProvider);
    return const MyApp();
  },
)
```

- Do this in a widget under `ProviderScope`, not bare `main()`, for predictable tests.
- `AsyncValue.requireValue` throws if data is not ready.

## 8. Side effects

```dart
@riverpod
class TodosNotifier extends _$TodosNotifier {
  Future<void> addTodo(Todo todo) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(repositoryProvider).addTodo(todo);
      return [...?state.value, todo];
    });
  }
}

ElevatedButton(
  onPressed: () => ref.read(todosNotifierProvider.notifier).addTodo(todo),
  child: const Text('Add'),
)
```

- Event handlers: `ref.read`, not `ref.watch`.
- After effects: set state, `ref.invalidateSelf()`, or update cache explicitly.
- Surface loading/error in UI.
- No side effects in provider constructors/`build` of notifiers.

## 9. Provider observers

```dart
class MyObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {
    print('[${context.provider}] updated: $previousValue → $newValue');
  }

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    // Report to error service
  }
}

runApp(ProviderScope(observers: [MyObserver()], child: MyApp()));
```

## 10. Testing

```dart
final container = ProviderContainer(
  overrides: [repositoryProvider.overrideWith((_) => FakeRepository())],
);
addTearDown(container.dispose);

expect(await container.read(todosProvider.future), isNotEmpty);

await tester.pumpWidget(
  ProviderScope(
    overrides: [repositoryProvider.overrideWith((_) => FakeRepository())],
    child: const MyApp(),
  ),
);
```

- New `ProviderContainer` or `ProviderScope` **per test** — no shared state.
- For autoDispose: `container.listen` can keep the provider alive during the test.
- Prefer overriding **repositories**, not Notifiers.
- If mocking a Notifier: **subclass** the real one — avoid `implements` or `with Mock`.
- Codegen: Notifier mocks often live **same file** as the Notifier.
- Widget tests: `ProviderScope.containerOf(tester.element(...))` for the container.

## References

- [Riverpod repository](https://github.com/rrousselGit/riverpod)
- Adapted from [evanca/flutter-ai-rules — riverpod skill](https://github.com/evanca/flutter-ai-rules/blob/main/skills/riverpod/SKILL.md)
