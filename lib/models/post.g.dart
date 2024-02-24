// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPostCollection on Isar {
  IsarCollection<Post> get posts => this.collection();
}

const PostSchema = CollectionSchema(
  name: r'Post',
  id: -1683556178151468304,
  properties: {
    r'content': PropertySchema(
      id: 0,
      name: r'content',
      type: IsarType.string,
    ),
    r'favorite': PropertySchema(
      id: 1,
      name: r'favorite',
      type: IsarType.bool,
    ),
    r'fullText': PropertySchema(
      id: 2,
      name: r'fullText',
      type: IsarType.bool,
    ),
    r'link': PropertySchema(
      id: 3,
      name: r'link',
      type: IsarType.string,
    ),
    r'pubDate': PropertySchema(
      id: 4,
      name: r'pubDate',
      type: IsarType.dateTime,
    ),
    r'read': PropertySchema(
      id: 5,
      name: r'read',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _postEstimateSize,
  serialize: _postSerialize,
  deserialize: _postDeserialize,
  deserializeProp: _postDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'feed': LinkSchema(
      id: 7631907602608560705,
      name: r'feed',
      target: r'Feed',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _postGetId,
  getLinks: _postGetLinks,
  attach: _postAttach,
  version: '3.1.0+1',
);

int _postEstimateSize(
  Post object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.link.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _postSerialize(
  Post object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeBool(offsets[1], object.favorite);
  writer.writeBool(offsets[2], object.fullText);
  writer.writeString(offsets[3], object.link);
  writer.writeDateTime(offsets[4], object.pubDate);
  writer.writeBool(offsets[5], object.read);
  writer.writeString(offsets[6], object.title);
}

Post _postDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Post(
    content: reader.readString(offsets[0]),
    favorite: reader.readBool(offsets[1]),
    fullText: reader.readBool(offsets[2]),
    id: id,
    link: reader.readString(offsets[3]),
    pubDate: reader.readDateTime(offsets[4]),
    read: reader.readBool(offsets[5]),
    title: reader.readString(offsets[6]),
  );
  return object;
}

P _postDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _postGetId(Post object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _postGetLinks(Post object) {
  return [object.feed];
}

void _postAttach(IsarCollection<dynamic> col, Id id, Post object) {
  object.id = id;
  object.feed.attach(col, col.isar.collection<Feed>(), r'feed', id);
}

extension PostQueryWhereSort on QueryBuilder<Post, Post, QWhere> {
  QueryBuilder<Post, Post, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PostQueryWhere on QueryBuilder<Post, Post, QWhereClause> {
  QueryBuilder<Post, Post, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Post, Post, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Post, Post, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Post, Post, QAfterWhereClause> idBetween(
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

extension PostQueryFilter on QueryBuilder<Post, Post, QFilterCondition> {
  QueryBuilder<Post, Post, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> favoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favorite',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> fullTextEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullText',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<Post, Post, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<Post, Post, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<Post, Post, QAfterFilterCondition> linkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'link',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'link',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'link',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'link',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> linkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'link',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> pubDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> pubDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> pubDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> pubDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> readEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'read',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension PostQueryObject on QueryBuilder<Post, Post, QFilterCondition> {}

extension PostQueryLinks on QueryBuilder<Post, Post, QFilterCondition> {
  QueryBuilder<Post, Post, QAfterFilterCondition> feed(FilterQuery<Feed> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'feed');
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> feedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'feed', 0, true, 0, true);
    });
  }
}

extension PostQuerySortBy on QueryBuilder<Post, Post, QSortBy> {
  QueryBuilder<Post, Post, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByFullText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullText', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByFullTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullText', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPubDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubDate', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPubDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubDate', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension PostQuerySortThenBy on QueryBuilder<Post, Post, QSortThenBy> {
  QueryBuilder<Post, Post, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByFullText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullText', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByFullTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullText', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'link', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPubDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubDate', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPubDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubDate', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension PostQueryWhereDistinct on QueryBuilder<Post, Post, QDistinct> {
  QueryBuilder<Post, Post, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favorite');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByFullText() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullText');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByLink(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'link', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByPubDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubDate');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'read');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension PostQueryProperty on QueryBuilder<Post, Post, QQueryProperty> {
  QueryBuilder<Post, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<Post, bool, QQueryOperations> favoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favorite');
    });
  }

  QueryBuilder<Post, bool, QQueryOperations> fullTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullText');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> linkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'link');
    });
  }

  QueryBuilder<Post, DateTime, QQueryOperations> pubDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubDate');
    });
  }

  QueryBuilder<Post, bool, QQueryOperations> readProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'read');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
