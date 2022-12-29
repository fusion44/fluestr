// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPreferencesCollection on Isar {
  IsarCollection<Preferences> get preferences => this.collection();
}

const PreferencesSchema = CollectionSchema(
  name: r'Preferences',
  id: 4252616732994050084,
  properties: {
    r'credentials': PropertySchema(
      id: 0,
      name: r'credentials',
      type: IsarType.object,
      target: r'Credentials',
    ),
    r'currentlyOnboarding': PropertySchema(
      id: 1,
      name: r'currentlyOnboarding',
      type: IsarType.bool,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'languageCode': PropertySchema(
      id: 3,
      name: r'languageCode',
      type: IsarType.string,
    ),
    r'onboardingFinished': PropertySchema(
      id: 4,
      name: r'onboardingFinished',
      type: IsarType.bool,
    ),
    r'stringify': PropertySchema(
      id: 5,
      name: r'stringify',
      type: IsarType.bool,
    ),
    r'theme': PropertySchema(
      id: 6,
      name: r'theme',
      type: IsarType.string,
    )
  },
  estimateSize: _preferencesEstimateSize,
  serialize: _preferencesSerialize,
  deserialize: _preferencesDeserialize,
  deserializeProp: _preferencesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Credentials': CredentialsSchema},
  getId: _preferencesGetId,
  getLinks: _preferencesGetLinks,
  attach: _preferencesAttach,
  version: '3.0.5',
);

int _preferencesEstimateSize(
  Preferences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      CredentialsSchema.estimateSize(
          object.credentials, allOffsets[Credentials]!, allOffsets);
  bytesCount += 3 + object.languageCode.length * 3;
  bytesCount += 3 + object.theme.length * 3;
  return bytesCount;
}

void _preferencesSerialize(
  Preferences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<Credentials>(
    offsets[0],
    allOffsets,
    CredentialsSchema.serialize,
    object.credentials,
  );
  writer.writeBool(offsets[1], object.currentlyOnboarding);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeString(offsets[3], object.languageCode);
  writer.writeBool(offsets[4], object.onboardingFinished);
  writer.writeBool(offsets[5], object.stringify);
  writer.writeString(offsets[6], object.theme);
}

Preferences _preferencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Preferences(
    credentials: reader.readObjectOrNull<Credentials>(
          offsets[0],
          CredentialsSchema.deserialize,
          allOffsets,
        ) ??
        Credentials(),
    currentlyOnboarding: reader.readBoolOrNull(offsets[1]) ?? false,
    languageCode: reader.readStringOrNull(offsets[3]) ?? 'en',
    onboardingFinished: reader.readBoolOrNull(offsets[4]) ?? false,
    theme: reader.readStringOrNull(offsets[6]) ?? 'light',
  );
  return object;
}

P _preferencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<Credentials>(
            offset,
            CredentialsSchema.deserialize,
            allOffsets,
          ) ??
          Credentials()) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? 'en') as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? 'light') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _preferencesGetId(Preferences object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _preferencesGetLinks(Preferences object) {
  return [];
}

void _preferencesAttach(
    IsarCollection<dynamic> col, Id id, Preferences object) {}

extension PreferencesQueryWhereSort
    on QueryBuilder<Preferences, Preferences, QWhere> {
  QueryBuilder<Preferences, Preferences, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PreferencesQueryWhere
    on QueryBuilder<Preferences, Preferences, QWhereClause> {
  QueryBuilder<Preferences, Preferences, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PreferencesQueryFilter
    on QueryBuilder<Preferences, Preferences, QFilterCondition> {
  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      currentlyOnboardingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentlyOnboarding',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'languageCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'languageCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      languageCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      onboardingFinishedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onboardingFinished',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      stringifyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stringify',
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      stringifyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stringify',
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      stringifyEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stringify',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      themeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'theme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      themeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'theme',
        value: '',
      ));
    });
  }
}

extension PreferencesQueryObject
    on QueryBuilder<Preferences, Preferences, QFilterCondition> {
  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> credentials(
      FilterQuery<Credentials> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'credentials');
    });
  }
}

extension PreferencesQueryLinks
    on QueryBuilder<Preferences, Preferences, QFilterCondition> {}

extension PreferencesQuerySortBy
    on QueryBuilder<Preferences, Preferences, QSortBy> {
  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByCurrentlyOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentlyOnboarding', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByCurrentlyOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentlyOnboarding', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByOnboardingFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingFinished', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByOnboardingFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingFinished', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByStringify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByStringifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }
}

extension PreferencesQuerySortThenBy
    on QueryBuilder<Preferences, Preferences, QSortThenBy> {
  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByCurrentlyOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentlyOnboarding', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByCurrentlyOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentlyOnboarding', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByOnboardingFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingFinished', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByOnboardingFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingFinished', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByStringify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByStringifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }
}

extension PreferencesQueryWhereDistinct
    on QueryBuilder<Preferences, Preferences, QDistinct> {
  QueryBuilder<Preferences, Preferences, QDistinct>
      distinctByCurrentlyOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentlyOnboarding');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByLanguageCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languageCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct>
      distinctByOnboardingFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingFinished');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByStringify() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stringify');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByTheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme', caseSensitive: caseSensitive);
    });
  }
}

extension PreferencesQueryProperty
    on QueryBuilder<Preferences, Preferences, QQueryProperty> {
  QueryBuilder<Preferences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Preferences, Credentials, QQueryOperations>
      credentialsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'credentials');
    });
  }

  QueryBuilder<Preferences, bool, QQueryOperations>
      currentlyOnboardingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentlyOnboarding');
    });
  }

  QueryBuilder<Preferences, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<Preferences, String, QQueryOperations> languageCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languageCode');
    });
  }

  QueryBuilder<Preferences, bool, QQueryOperations>
      onboardingFinishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingFinished');
    });
  }

  QueryBuilder<Preferences, bool?, QQueryOperations> stringifyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stringify');
    });
  }

  QueryBuilder<Preferences, String, QQueryOperations> themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }
}
