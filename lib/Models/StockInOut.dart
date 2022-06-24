import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/DateFormatForDB.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Stock.dart';
import 'package:inventory_second/Models/Trantype.dart';
import 'package:inventory_second/Models/Type.dart';

class StockInOut extends Stock {
  Trantype? trantype;
  DateTimeRange? rangeDate;
  StockInOut(
      {Trantype? trantype, Size? s, Shade? shade, Type? t, DateTimeRange? r})
      : super.t(s, shade, t) {
    this.trantype = trantype;
    this.rangeDate = r;
    this.size = s;
    this.shade = shade;
    this.type = t;
    this.query = this.draftQuery();
  }

  String draftQuery() {
    String? decider = '';

    if (shade!.id != -1 && !decider.contains("a.shade")) {
      decider += " and a.shade = ${shade!.id} ";
    }

    if (size!.id != -1 && !decider.contains("a.size")) {
      decider += " and a.size = ${size!.id} ";
    }

    if (type!.id != -1 && !decider.contains("a.type")) {
      decider += " and a.type = ${type!.id} ";
    }

    if (trantype!.id != -1 && !decider.contains("a.trantype")) {
      decider += " and a.trantype = ${trantype!.id} ";
    }

    String? draft_query = '''

    select b.size,c.shade,d.type, a.tranref,a.trandate,
    ba.Trantype,ca.rollsize,a.rolls,a.mtrs
    from transactions a
    left join size b on a.size = b.id
    left join shade c on a.shade = c.id
    left join type d on a.type = d.id
    left join trantype ba on a.trantype = ba.id
    left join  rollsize ca on a.rollsize = ca.id
    where 0 = 0 $decider and trandate between '${formateDate(this.rangeDate!.start)}' and  '${formateDate(this.rangeDate!.end)}'
    order by a.trandate
  
  ''';
    return draft_query;
  }
}
