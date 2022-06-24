import 'package:inventory_second/Interface/Model_Interface.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Type.dart';

class Stock implements Model {
  Size? size;
  Shade? shade;
  Type? type;
  String? query;

  Stock.t(Size? s, Shade? shade, Type? t) {
    // constructor only for stockinout
    this.shade = shade;
    this.size = s;
    this.type = t;
  }

  Stock({Size? s, Shade? shade, Type? t}) {
    this.shade = shade;
    this.size = s;
    this.type = t;
    this.query = this.draftQuery();
  }

  String draftQuery() {
    String? decider = '';

    if (this.shade!.id != -1 && !decider.contains("a.shade")) {
      decider += " and a.shade = ${this.shade!.id} ";
    }

    if (this.size!.id != -1 && !decider.contains("a.size")) {
      decider += " and a.size = ${this.size!.id} ";
    }

    if (this.type!.id != -1 && !decider.contains("a.type")) {
      decider += " and a.type = ${this.type!.id} ";
    }

    String? draft_query = '''

  select
  b.size,c.shade,d.type, e.rollsize as roll_size,
  ISNULL((select sum(rolls) from transactions where trantype = 1 and
  size = a.size and shade = a.shade and type = a.type and rollsize = a.rollsize),0) -
  ISNULL((select sum(rolls) from transactions where trantype = 2 and
  size = a.size and shade = a.shade and type = a.type  and rollsize = a.rollsize),0) as rolls,
  ISNULL((select sum(mtrs) from transactions where trantype = 1 and
  size = a.size and shade = a.shade and type = a.type  and rollsize = a.rollsize),0) -
  ISNULL((select sum(mtrs) from transactions where trantype = 2 and
  size = a.size and shade = a.shade and type = a.type  and rollsize = a.rollsize),0) as mtrs
  ,a.size,a.shade,a.type,a.rollsize,c.rvalue,c.bvalue,c.gvalue
  from
  transactions a
  left join size b on a.size = b.id
  left join shade c on a.shade = c.id
  left join type d on a.type = d.id
  left join rollsize e on a.rollsize = e.id
  where 0 = 0 $decider
  group by b.size,c.shade,d.type,a.rollsize,a.size,a.shade,a.type,e.rollsize,c.rvalue,c.bvalue,c.gvalue
  order by c.shade, b.size,d.type,c.rvalue,c.bvalue,c.gvalue
  
  ''';
    return draft_query;
  }

  @override
  display() {
    return "Stock Display";
  }

  @override
  format(List li) {
    return li;
  }

  @override
  getQuery() {
    return this.query;
  }
}
