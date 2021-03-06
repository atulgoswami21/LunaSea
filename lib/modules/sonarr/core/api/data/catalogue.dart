import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunasea/core.dart';

class SonarrCatalogueData {
    final Map<String, dynamic> api = Database.currentProfileObject.getSonarr();
    String title;
    String sortTitle;
    String status;
    String previousAiring;
    String nextAiring;
    String network;
    String overview;
    String path;
    String type;
    List<dynamic> seasonData;
    int qualityProfile;
    int seasonCount;
    int episodeCount;
    int episodeFileCount;
    int seriesID;
    String profile;
    bool seasonFolder;
    bool monitored;
    int tvdbId;
    int tvMazeId;
    String imdbId;
    int runtime;
    int sizeOnDisk;

    SonarrCatalogueData({
        @required this.title,
        @required this.sortTitle,
        @required this.seasonCount,
        @required this.seasonData,
        @required this.episodeCount,
        @required this.episodeFileCount,
        @required this.status,
        @required this.seriesID,
        @required this.previousAiring,
        @required this.nextAiring,
        @required this.network,
        @required this.monitored,
        @required this.path,
        @required this.qualityProfile,
        @required this.type,
        @required this.seasonFolder,
        @required this.overview,
        @required this.tvdbId,
        @required this.tvMazeId,
        @required this.imdbId,
        @required this.runtime,
        @required this.profile,
        @required this.sizeOnDisk,
    });

    DateTime get nextAiringObject {
        return DateTime.tryParse(nextAiring)?.toLocal();
    }

    DateTime get previousAiringObject {
        return DateTime.tryParse(previousAiring)?.toLocal();
    }

    String get seasonCountString {
        return seasonCount == 1 ? '$seasonCount Season' : '$seasonCount Seasons';
    }

    String get nextEpisode {
        if(nextAiringObject != null) {
            return DateFormat('MMMM dd, y').format(nextAiringObject);
        }
        return 'Unknown';
    }

    String get airTimeString {
        if(previousAiringObject != null) {
            return DateFormat('hh:mm a').format(previousAiringObject);
        }
        return 'Unknown';
    }

    String get subtitle {
        String size = sizeOnDisk?.lsBytes_BytesToString();
        if(previousAiringObject != null) {
            if(network == null) {
                return status == 'ended' ?
                    '$seasonCountString (Ended)\t•\t$size\nAired on Unknown' :
                    '$seasonCountString\t•\t$size\n${DateFormat('hh:mm a').format(previousAiringObject)} on Unknown';
            }
            return status == 'ended' ?
                '$seasonCountString (Ended)\t•\t$size\nAired on $network' :
                '$seasonCountString\t•\t$size\n${DateFormat('hh:mm a').format(previousAiringObject)} on $network';
        } else {
            if(network == null) {
                return status == 'ended' ? 
                    '$seasonCountString (Ended)\t•\t$size\nAired on Unknown' :
                    '$seasonCountString\t•\t$size\nAirs on Unknown';
            }
            return status == 'ended' ? 
                '$seasonCountString (Ended)\t•\t$size\nAired on $network' :
                '$seasonCountString\t•\t$size\nAirs on $network';
        }
    }

    String posterURI({bool highRes = false}) {
        if(api['enabled']) {
            return highRes
                ? '${api['host']}/api/mediacover/$seriesID/poster.jpg?apikey=${api['key']}'
                : '${api['host']}/api/mediacover/$seriesID/poster-500.jpg?apikey=${api['key']}';
        }
        return '';
    }

    String fanartURI({bool highRes = false}) {
        if(api['enabled']) {
            return highRes
                ? '${api['host']}/api/mediacover/$seriesID/fanart.jpg?apikey=${api['key']}'
                : '${api['host']}/api/mediacover/$seriesID/fanart-360.jpg?apikey=${api['key']}'; 
        }
        return '';
    }

    String bannerURI({bool highRes = false}) {
        if(api['enabled']) {
            return highRes
                ? '${api['host']}/api/mediacover/$seriesID/banner.jpg?apikey=${api['key']}'
                : '${api['host']}/api/mediacover/$seriesID/banner-70.jpg?apikey=${api['key']}'; 
        }
        return '';
    }
}