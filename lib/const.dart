import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const GOOGLE_MAPS_API_KEY = "AIzaSyByvUKtlUfbXTa5DEsGiUwPJXbILaNsUUg";
const earthRadius = 6371; //km
const Map stationPositions = {
    'Islamabad International Airport':
        LatLng(33.56095189895278, 72.83700608010443),
    '26 Number': LatLng(33.6322, 72.9445),
    'Golra': LatLng(33.6406, 72.9617),
    'G-13': LatLng(33.6496, 72.9817),
    'G-12': LatLng(33.6560, 72.9933),
    'G-11': LatLng(33.6630, 73.0074),
    'G-10': LatLng(33.6677, 73.0162),
    'G-9': LatLng(33.6773, 73.0347),
    'Faiz Ahmad Faiz': LatLng(33.6760, 73.0550),
    'Kashmir Highway': LatLng(33.6852, 73.0460),
    'Chaman': LatLng(33.6900, 73.0428),
    'Ibn-e-Sina': LatLng(33.69644905648759, 73.03787753824244),
    'Katchery': LatLng(33.702277863666204, 73.04095186708203),
    'Centaurus': LatLng(33.705782187100176, 73.04800458576659),
    'Stock Exchange': LatLng(33.711776123432024, 73.05929907233532),
    '7th Avenue': LatLng(33.71820764009457, 73.07122404926015),
    'Shaheed-e-Millat': LatLng(33.72171475110865, 73.07838322360071),
    'Parade Ground': LatLng(33.724787448975356, 73.08440118751071),
    'Pak Secteriat': LatLng(33.73520048315413, 73.09240868463804),
    'Khayaban-e-Johar': LatLng(33.669269533315536, 73.05926209299133),
    'Potohar': LatLng(33.661339247653224, 73.06533269353748),
    'IJP': LatLng(33.656279745233846, 73.07169728444373),
    'Faizabad': LatLng(33.661439645834534, 73.08285873967888),
    'Shamsabad': LatLng(33.650559681688584, 73.07987327890962),
    '6th Road': LatLng(33.64343291633432, 73.07769155117246),
    'Rehmanabad': LatLng(33.63630855661862, 73.07491837615183),
    'Chandni Chowk': LatLng(33.62964818779046, 73.0716458948337),
    'Waris Khan': LatLng(33.62227647847515, 73.06686863325669),
    'Committee Chowk': LatLng(33.613427486726145, 73.06468910324138),
    'Liaquat Bagh': LatLng(33.60611998948246, 73.06567619296001),
    'Marir Chowk': LatLng(33.59951162680857, 73.0626556170475),
    'Saddar': LatLng(33.59380798939582, 73.05603698821746),
  };
Location location = Location();
Set<Marker> stationMarkers = {};
