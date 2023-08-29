import 'package:xml/xml.dart';

import '../../domain/media/category.dart';
import '../../domain/media/community.dart';
import '../../domain/media/content.dart';
import '../../domain/media/copyright.dart';
import '../../domain/media/credit.dart';
import '../../domain/media/description.dart';
import '../../domain/media/embed.dart';
import '../../domain/media/group.dart';
import '../../domain/media/hash.dart';
import '../../domain/media/license.dart';
import '../../domain/media/peer_link.dart';
import '../../domain/media/player.dart';
import '../../domain/media/price.dart';
import '../../domain/media/rating.dart';
import '../../domain/media/restriction.dart';
import '../../domain/media/rights.dart';
import '../../domain/media/scene.dart';
import '../../domain/media/status.dart';
import '../../domain/media/text.dart';
import '../../domain/media/thumbnail.dart';
import '../../domain/media/title.dart';
import '../../util/xml.dart';
import '../../util/iterable.dart';

class Media {
  final Group? group;
  final List<Content>? contents;
  final List<Credit>? credits;
  final Category? category;
  final Rating? rating;
  final Title? title;
  final Description? description;
  final String? keywords;
  final List<Thumbnail>? thumbnails;
  final Hash? hash;
  final Player? player;
  final Copyright? copyright;
  final Text? text;
  final Restriction? restriction;
  final Community? community;
  final List<String>? comments;
  final Embed? embed;
  final List<String>? responses;
  final List<String>? backLinks;
  final Status? status;
  final List<Price>? prices;
  final License? license;
  final PeerLink? peerLink;
  final Rights? rights;
  final List<Scene>? scenes;

  Media({
    this.group,
    this.contents,
    this.credits,
    this.category,
    this.rating,
    this.title,
    this.description,
    this.keywords,
    this.thumbnails,
    this.hash,
    this.player,
    this.copyright,
    this.text,
    this.restriction,
    this.community,
    this.comments,
    this.embed,
    this.responses,
    this.backLinks,
    this.status,
    this.prices,
    this.license,
    this.peerLink,
    this.rights,
    this.scenes,
  });

  factory Media.parse(XmlElement element) {
    return Media(
      group: element
          .findElements('media:group')
          .map((e) => Group.parse(e))
          .firstOrNull,
      contents: element
          .findElements('media:content')
          .map((e) => Content.parse(e))
          .toList(),
      credits: element
          .findElements('media:credit')
          .map((e) => Credit.parse(e))
          .toList(),
      category: element
          .findElements('media:category')
          .map((e) => Category.parse(e))
          .firstOrNull,
      rating: element
          .findElements('media:rating')
          .map((e) => Rating.parse(e))
          .firstOrNull,
      title: findElements(element, 'media:title')
          ?.map((e) => Title.parse(e))
          .firstOrNull,
      description: element
          .findElements('media:description')
          .map((e) => Description.parse(e))
          .firstOrNull,
      keywords: element.findElements('media:keywords').firstOrNull?.innerText,
      thumbnails: element
          .findElements('media:thumbnail')
          .map((e) => Thumbnail.parse(e))
          .toList(),
      hash: element
          .findElements('media:hash')
          .map((e) => Hash.parse(e))
          .firstOrNull,
      player: element
          .findElements('media:player')
          .map((e) => Player.parse(e))
          .firstOrNull,
      copyright: element
          .findElements('media:copyright')
          .map((e) => Copyright.parse(e))
          .firstOrNull,
      text: element
          .findElements('media:text')
          .map((e) => Text.parse(e))
          .firstOrNull,
      restriction: element
          .findElements('media:restriction')
          .map((e) => Restriction.parse(e))
          .firstOrNull,
      community: element
          .findElements('media:community')
          .map((e) => Community.parse(e))
          .firstOrNull,
      comments: element
              .findElements('media:comments')
              .firstOrNull
              ?.findElements('media:comment')
              .map((e) => e.innerText)
              .toList() ??
          [],
      embed: element
          .findElements('media:embed')
          .map((e) => Embed.parse(e))
          .firstOrNull,
      responses: element
              .findElements('media:responses')
              .firstOrNull
              ?.findElements('media:response')
              .map((e) => e.innerText)
              .toList() ??
          [],
      backLinks: element
              .findElements('media:backLinks')
              .firstOrNull
              ?.findElements('media:backLink')
              .map((e) => e.innerText)
              .toList() ??
          [],
      status: element
          .findElements('media:status')
          .map((e) => Status.parse(e))
          .firstOrNull,
      prices: element
          .findElements('media:price')
          .map((e) => Price.parse(e))
          .toList(),
      license: element
          .findElements('media:license')
          .map((e) => License.parse(e))
          .firstOrNull,
      peerLink: element
          .findElements('media:peerLink')
          .map((e) => PeerLink.parse(e))
          .firstOrNull,
      rights: element
          .findElements('media:rights')
          .map((e) => Rights.parse(e))
          .firstOrNull,
      scenes: element
              .findElements('media:scenes')
              .firstOrNull
              ?.findElements('media:scene')
              .map((e) => Scene.parse(e))
              .toList() ??
          [],
    );
  }
}
