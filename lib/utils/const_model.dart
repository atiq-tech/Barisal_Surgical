//String baseUrl = "http://192.168.0.127:82/api/v1/"; //local
//String baseUrl = "https://demo.magiccorperp.com/api/v1/"; //sub
String imageBaseUrl = "https://api.swiftsurgical.net/";//imgUrlbase
String baseUrl = "https://api.swiftsurgical.net/api/v1/";//sub

List dashboardItems = [
    {"name": "Order Entry", "image": "images/orderEntry.png"},
    {"name": "Order Record", "image": "images/orderRecord.png"},
    {"name": "Order Invoice", "image": "images/orderInvoice.png"},

    {"name": "Sales Entry", "image": "images/salesEntry.png"},
    {"name": "Sales Record", "image": "images/srecord.png"},
    {"name": "Sales Invoice", "image": "images/sInvc.png"},
    
    {"name": "Product List", "image": "images/productlist.png"},
    {"name": "Category List", "image": "images/catelist.png"},
    // {"name": "Customer Entry", "image": "images/ccentry.png"},
    {"name": "Customer List", "image": "images/customerlist.png"},
    // {"name": "My Profile", "image": "images/mpofile.png"},
    {"name": "Logout", "image": "images/logout.png"},
    //{"name": "Attendance Report", "image": "images/attend.png"},
    {"name": "Visit Entry", "image": "images/visite.png"},
    {"name": "Visit List", "image": "images/vhistory.png"},
    //{"name": "Add Fingerprint", "image": "images/fngr.png"},
  ];

List orderModuleItems = [
  {"name": "Order Entry", "image": "images/orderEntry.png"},
  {"name": "Order Record", "image": "images/orderRecord.png"},
  {"name": "Order Invoice", "image": "images/orderInvoice.png"},
];
final orderDrawerList = [
  "Order Entry",
  "Order Record",
  "Order Invoice"
];
List salesModuleItems = [
  {"name": "Sales Entry", "image": "images/salesEntry.png"},
  {"name": "Sales Record", "image": "images/srecord.png"},
  {"name": "Sales Invoice", "image": "images/sInvc.png"},
];

final salesDrawerList = [
  "Sales Entry",
  "Sales Record",
  "Sales Invoice"
];

List administrationItems = [
  {"name": "Product List", "image": "images/plist.png"},
  {"name": "Category List", "image": "images/catelist.png"},
  {"name": "Customer Entry", "image": "images/centry.png"},

  {"name": "Customer List", "image": "images/clist.png"},
  //{"name": "Visit Entry", "image": "images/ventry.png"},
  //{"name": "Visit History", "image": "images/vhistory.png"},
  //{"name": "Attendance Entry", "image": "images/attendance.png"},
  {"name": "My Profile", "image": "images/mpofile.png"},
  {"name": "Logout", "image": "images/logout.png"},
];
final administrationDrawerList = [
  "Product List",
  "Category List",
  "Customer Entry",
  "Customer List",
  //"Visit Entry",
  //"Visit History",
  //"Attendance Entry",
  "My Profile",
];

class AddToOrderModel {
  String? productId;
  String? productName;
  String? productImage;
  String? salesRate;
  String? boxQuantity;
  String? quantity;
  String? total;

  AddToOrderModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.salesRate,
    required this.boxQuantity,
    required this.quantity,
    required this.total,
  });
}