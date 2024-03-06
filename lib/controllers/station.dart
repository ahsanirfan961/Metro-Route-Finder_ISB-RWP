import 'package:metro_route_finder/const.dart';

class Station {
  Station({required this.id});
  String id;
  Station? next;

  static Station addStation(Station head, String id) {
    Station current = head;
    Station q = Station(id: id);
    while (current.next != null) {
      current = current.next!;
    }
    current.next = q;
    return head;
  }
}

class StationLayout {
  Map<String, Station> stations = {};
  List<String> _route = [];

  StationLayout() {
    List<Station> list = [];
    for (var i in stationPositions.keys) {
      list.add(Station(id: i));
    }
    for (int i = 0; i < 18; i++) {
      if (i > 0) Station.addStation(list[i], list[i - 1].id);
      Station.addStation(list[i], list[i + 1].id);
    }
    Station.addStation(list[18], list[18 - 1].id);
    Station.addStation(list[8], list[19].id);
    Station.addStation(list[19], list[8].id);
    Station.addStation(list[19], list[20].id);
    for (int i = 20; i <= 31; i++) {
      if (i < 31) Station.addStation(list[i], list[i + 1].id);
      Station.addStation(list[i], list[i - 1].id);
    }
    int j = 0;
    for (var i in stationPositions.keys) {
      stations[i] = list[j];
      j++;
    }
  }

  void printlayout() {
    for (var i in stations.values) {
      var current = i;
      String llist = current.id + " >> ";
      while (current.next != null) {
        current = current.next!;
        llist += current.id + " >> ";
      }
      print(llist);
    }
  }

  bool _dfs(String source, String destination, Map<String, bool> flags) {
    _route.add(source);
    flags[source] = true;
    if (stations[source]!.next == null) {
      return false;
    }
    if (source == destination) return true;

    Station? adjacent = stations[source]!.next;
    while (adjacent != null) {
      if (flags[adjacent.id] == false) {
        if (_dfs(adjacent.id, destination, flags)) return true;
      }
      adjacent = adjacent.next;
    }

    _route.removeLast();
    return false;
  }

  List<String> pathBetween(String source, String destination) {
    Map<String, bool> flags = {};
    _route = [];
    for (var i in stationPositions.keys) {
      flags[i] = false;
    }
    _dfs(source, destination, flags);
    return _route;
  }
}