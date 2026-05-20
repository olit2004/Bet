# Frontend Migration & Fixes Guide: Migrating to Riverpod 3 and SQLite Caching

To align the frontend codebase with the updated project specifications, you must refactor the state management system from the legacy `provider` package to **Riverpod 3** and integrate an **SQLite local caching layer** within the data repository layer.

---

## 🛠️ Step 1: Update Dependencies (`pubspec.yaml`)

Remove the `provider` package and add `flutter_riverpod` and local persistence dependencies (`sqflite`, `path`).

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management (Riverpod 3)
  flutter_riverpod: ^3.0.0-beta.0  # Or latest Riverpod 3 beta/release version

  # Caching (SQLite)
  sqflite: ^2.3.0
  path: ^1.9.0
  
  # Networking
  dio: ^5.4.0
  
  # Existing packages
  cupertino_icons: ^1.0.8
  go_router: ^17.2.2
  google_fonts: ^8.0.2
  intl: ^0.20.2
  flutter_map: ^8.3.0
  latlong2: ^0.9.1
```

*Run `flutter pub get` after updating.*

---

## 🚀 Step 2: Main Application Initialization (`lib/main.dart`)

Wrap the entire widget tree in a `ProviderScope` to enable Riverpod, and initialize the SQLite database before running the app.

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/core/routing/app_router.dart';
import 'package:bet/core/theme/app_theme.dart';
import 'package:bet/core/database/local_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the SQLite local database cache
  await LocalDatabase.instance.database;

  runApp(
    // ProviderScope is required for Riverpod to store state
    const ProviderScope(
      child: BethApp(),
    ),
  );
}

class BethApp extends ConsumerWidget {
  const BethApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Bet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
```

---

## 💾 Step 3: SQLite Cache Helper (`lib/core/database/local_database.dart`)

Implement a singleton database manager class using `sqflite` to manage local SQLite tables.

```dart
// lib/core/database/local_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  LocalDatabase._privateConstructor();
  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bet_cache.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create properties cache table
    await db.execute('''
      CREATE TABLE properties (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        price REAL,
        latitude REAL,
        longitude REAL,
        type TEXT,
        status TEXT,
        ownerId TEXT,
        createdAt TEXT
      )
    ''');
    
    // Add additional tables for bids, proposals, and notifications as needed.
  }
}
```

---

## 🔄 Step 4: Repository Cache Coordination Logic

In your repository implementations, enforce the **cache hit first, fallback to network** strategy.

```dart
// lib/core/property/repositories/property_repository_impl.dart
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/core/property/repositories/property_repository.dart';
import 'package:bet/core/database/local_database.dart';
import 'package:sqflite/sqflite.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  // Remote API data source (e.g. Dio Client)
  final RemotePropertyDataSource _remoteDataSource;
  
  PropertyRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PropertyModel>> getProperties() async {
    final db = await LocalDatabase.instance.database;

    // 1. Try to fetch from SQLite local cache
    final List<Map<String, dynamic>> cachedData = await db.query('properties');

    if (cachedData.isNotEmpty) {
      // Cache Hit: Convert SQL rows to Models and return immediately
      return cachedData.map((json) => PropertyModel.fromJson(json)).toList();
    }

    // 2. Cache Miss: Query the remote API
    try {
      final List<PropertyModel> remoteProperties = await _remoteDataSource.fetchProperties();

      // 3. Write newly fetched data into SQLite cache for future requests
      final batch = db.batch();
      for (var property in remoteProperties) {
        batch.insert(
          'properties',
          property.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);

      return remoteProperties;
    } catch (e) {
      // Return empty list or throw custom domain failure on connection issue
      rethrow;
    }
  }
}
```

---

## 🎛️ Step 5: Convert Providers to Riverpod 3

Convert existing standard ChangeNotifiers (such as `PropertyProvider` and `NavigationProvider`) to Riverpod Notifiers.

### Before (Standard Provider):
```dart
class PropertyProvider extends ChangeNotifier { ... }
```

### After (Riverpod 3 Notifier):
```dart
// lib/core/property/providers/property_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/core/property/repositories/property_repository_impl.dart';

// Riverpod Provider for Repository
final propertyRepositoryProvider = Provider((ref) {
  return PropertyRepositoryImpl(RemotePropertyDataSource());
});

// Riverpod Notifier for Properties State
final propertiesNotifierProvider = AsyncNotifierProvider<PropertiesNotifier, List<PropertyModel>>(() {
  return PropertiesNotifier();
});

class PropertiesNotifier extends AsyncNotifier<List<PropertyModel>> {
  @override
  Future<List<PropertyModel>> build() async {
    final repository = ref.watch(propertyRepositoryProvider);
    return repository.getProperties();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(propertyRepositoryProvider);
      return repository.getProperties();
    });
  }
}
```

---

## 📱 Step 6: Refactor UI Components to Read Riverpod

Modify your screens and widgets to consume state using a `ConsumerWidget` or a `Consumer` builder.

```dart
// lib/features/buyer/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/core/property/providers/property_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch property states reactively
    final propertiesState = ref.watch(propertiesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Local Properties')),
      body: propertiesState.when(
        data: (properties) => ListView.builder(
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            return ListTile(
              title: Text(property.title),
              subtitle: Text('\$${property.price}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading properties: $err')),
      ),
    );
  }
}
```
