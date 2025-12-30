// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;

class RouteBreadcrumbModel {
  final String title;
  final String parentRoute;
  final String childRoute;
  const RouteBreadcrumbModel({
    required this.title,
    required this.parentRoute,
    required this.childRoute,
  });

  @override
  String toString() {
    return 'RouteBreadcrumbModel(parentName: $parentRoute, childName: $childRoute)';
  }
}

Map<String, RouteBreadcrumbModel> get routerParam {
  return {
    '/dashboard/open-ai-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'Open AI Admin',
    ),
    '/dashboard/erp-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'ERP Admin',
    ),
    '/dashboard/pos-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'POS Admin',
    ),
    '/dashboard/earning-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'Earning Admin',
    ),
    '/dashboard/sms-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'SMS Admin',
    ),
    '/dashboard/influencer-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'Influencer Admin',
    ),
    '/dashboard/hrm-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'HRM Admin',
    ),
    '/dashboard/news-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'News Admin',
    ),
    '/dashboard/ecommerce-admin': RouteBreadcrumbModel(
      //title: 'Dashboard',
      title: l.S.current.dashboard,
      parentRoute: 'Dashboard',
      childRoute: 'eCommerce Admin',
    ),
    '/widgets/general-widgets': RouteBreadcrumbModel(
      // title: 'General',
      title: l.S.current.general,
      parentRoute: 'Widgets',
      childRoute: 'General',
    ),
    '/widgets/chart-widgets': RouteBreadcrumbModel(
      //title: 'Chart',
      title: l.S.current.chart,
      parentRoute: 'Widgets',
      childRoute: 'Chart',
    ),
    '/calendar': RouteBreadcrumbModel(
      //title: 'Calendar',
      title: l.S.current.calendar,
      parentRoute: 'Application',
      childRoute: 'Calendar',
    ),
    '/chat': RouteBreadcrumbModel(
      //title: 'Chat',
      title: l.S.current.chat,
      parentRoute: 'Application',
      childRoute: 'Chat',
    ),
    '/email/inbox': RouteBreadcrumbModel(
      //title: 'Inbox',
      title: l.S.current.inbox,
      parentRoute: 'Application / Email',
      childRoute: 'Inbox',
    ),
    '/email/starred': RouteBreadcrumbModel(
      //title: 'Starred',
      title: l.S.current.starred,
      parentRoute: 'Application / Email',
      childRoute: 'Starred',
    ),
    '/email/sent': RouteBreadcrumbModel(
      //title: 'Sent',
      title: l.S.current.sent,
      parentRoute: 'Application / Email',
      childRoute: 'Sent',
    ),
    '/email/drafts': RouteBreadcrumbModel(
      // title: 'Drafts',
      title: l.S.current.drafts,
      parentRoute: 'Application / Email',
      childRoute: 'Drafts',
    ),
    '/email/spam': RouteBreadcrumbModel(
      //title: 'Spam',
      title: l.S.current.spam,
      parentRoute: 'Application / Email',
      childRoute: 'Spam',
    ),
    '/email/trash': RouteBreadcrumbModel(
      //title: 'Trash',
      title: l.S.current.trash,
      parentRoute: 'Application / Email',
      childRoute: 'Trash',
    ),
    '/email/details': RouteBreadcrumbModel(
      //title: 'Details',
      title: l.S.current.details,
      parentRoute: 'Application / Email',
      childRoute: 'Details',
    ),
    '/projects': RouteBreadcrumbModel(
      //title: 'Projects',
      title: l.S.current.projects,
      parentRoute: 'Application',
      childRoute: 'Projects',
    ),
    '/kanban': RouteBreadcrumbModel(
      // title: 'Kanban',
      title: l.S.current.kanban,
      parentRoute: 'Application',
      childRoute: 'Kanban',
    ),
    '/ecommerce/product-list': RouteBreadcrumbModel(
      // title: 'eCommerce',
      title: l.S.current.eCommerce,
      parentRoute: 'eCommerce ',
      childRoute: 'Product List',
    ),
    '/ecommerce/product-details': RouteBreadcrumbModel(
      // title: 'eCommerce',
      title: l.S.current.eCommerce,
      parentRoute: 'eCommerce ',
      childRoute: 'Product Details',
    ),
    '/ecommerce/cart': RouteBreadcrumbModel(
      // title: 'eCommerce',
      title: l.S.current.eCommerce,
      parentRoute: 'eCommerce ',
      childRoute: 'Cart',
    ),
    '/ecommerce/checkout': RouteBreadcrumbModel(
      //title: 'eCommerce',
      title: l.S.current.eCommerce,
      parentRoute: 'eCommerce ',
      childRoute: 'Checkout',
    ),
    '/pos-inventory/sale': RouteBreadcrumbModel(
      // title: 'POSInventory',
      title: l.S.current.POSInventory,
      parentRoute: 'POS & Inventory',
      childRoute: 'POS Sale',
    ),
    '/pos-inventory/sale-list': RouteBreadcrumbModel(
      // title: 'POSInventory',
      title: l.S.current.POSInventory,
      parentRoute: 'POS & Inventory',
      childRoute: 'Sale List',
    ),
    '/pos-inventory/purchase': RouteBreadcrumbModel(
      // title: 'POSInventory',
      title: l.S.current.POSInventory,
      parentRoute: 'POS & Inventory',
      childRoute: 'Purchase',
    ),
    '/pos-inventory/purchase-list': RouteBreadcrumbModel(
      // title: 'POSInventory',
      title: l.S.current.POSInventory,
      parentRoute: 'POS & Inventory',
      childRoute: 'Purchase List',
    ),
    '/pos-inventory/product': RouteBreadcrumbModel(
      // title: 'POSInventory',
      title: l.S.current.POSInventory,
      parentRoute: 'POS & Inventory',
      childRoute: 'Product',
    ),
    '/open-ai/ai-writter': RouteBreadcrumbModel(
      //title: 'AI Writer',
      title: l.S.current.aIWriter,
      parentRoute: 'Application / Open AI',
      childRoute: 'AI Writer',
    ),
    '/open-ai/ai-image': RouteBreadcrumbModel(
      //title: 'AI Image',
      title: l.S.current.aIImage,
      parentRoute: 'Application / Open AI',
      childRoute: 'AI Image',
    ),
    '/open-ai/ai-chat': RouteBreadcrumbModel(
      //title: 'AI Chat',
      title: l.S.current.aIChat,
      parentRoute: 'Application / Open AI',
      childRoute: 'AI Chat',
    ),
    '/open-ai/ai-code': RouteBreadcrumbModel(
      //title: 'AI Code',
      title: l.S.current.aICode,
      parentRoute: 'Application / Open AI',
      childRoute: 'AI Code',
    ),
    '/open-ai/ai-voiceover': RouteBreadcrumbModel(
      //title: 'AI Voiceover',
      title: l.S.current.aIVoiceover,
      parentRoute: 'Application / Open AI',
      childRoute: 'AI Voiceover',
    ),
    '/users/user-list': RouteBreadcrumbModel(
      //title: 'Users List',
      title: l.S.current.usersList,
      parentRoute: 'Application / Users',
      childRoute: 'Users List',
    ),
    '/users/user-grid': RouteBreadcrumbModel(
      //title: 'Users Grid',
      title: l.S.current.usersGrid,
      parentRoute: 'Application / Users',
      childRoute: 'Users Grid',
    ),
    '/users/user-profile': RouteBreadcrumbModel(
      //title: 'User Profile',
      title: l.S.current.userProfile,
      parentRoute: 'Application / Users',
      childRoute: 'User Profile',
    ),
    '/tables/basic-table': RouteBreadcrumbModel(
      //title: 'Basic Table',
      title: l.S.current.basicTable,
      parentRoute: 'Tables & Forms',
      childRoute: 'Basic Table',
    ),
    '/tables/data-table': RouteBreadcrumbModel(
      //title: 'Data Table',
      title: l.S.current.dataTable,
      parentRoute: 'Tables & Forms',
      childRoute: 'Data Table',
    ),
    '/forms/basic-forms': RouteBreadcrumbModel(
      //title: 'Basic Forms',
      title: l.S.current.basicForms,
      parentRoute: 'Table & Forms',
      childRoute: 'Basic Forms',
    ),
    '/forms/form-select': RouteBreadcrumbModel(
      // title: 'Form Select',
      title: l.S.current.formSelect,
      parentRoute: 'Tables & Forms',
      childRoute: 'Form Select',
    ),
    '/forms/form-validation': RouteBreadcrumbModel(
      //title: 'Form Validation',
      title: l.S.current.formValidation,
      parentRoute: 'Tables & Forms',
      childRoute: 'Form Validation',
    ),
    '/components/buttons': RouteBreadcrumbModel(
      //title: 'Buttons',
      title: l.S.current.buttons,
      parentRoute: 'Components',
      childRoute: 'Buttons',
    ),
    '/components/colors': RouteBreadcrumbModel(
      //title: 'Colors',
      title: l.S.current.colors,
      parentRoute: 'Components',
      childRoute: 'Colors',
    ),
    '/components/alerts': RouteBreadcrumbModel(
      //title: 'Alerts',
      title: l.S.current.alerts,
      parentRoute: 'Components',
      childRoute: 'Alerts',
    ),
    '/components/typography': RouteBreadcrumbModel(
      //title: 'Typography',
      title: l.S.current.typography,
      parentRoute: 'Components',
      childRoute: 'Typography',
    ),
    '/components/cards': RouteBreadcrumbModel(
      //title: 'Cards',
      title: l.S.current.cards,
      parentRoute: 'Components',
      childRoute: 'Cards',
    ),
    '/components/avatars': RouteBreadcrumbModel(
      //title: 'Avatars',
      title: l.S.current.avatars,
      parentRoute: 'Components',
      childRoute: 'Avatars',
    ),
    '/components/dragndrop': RouteBreadcrumbModel(
      //title: 'Drag & Drop',
      title: l.S.current.dragDrop,
      parentRoute: 'Components',
      childRoute: 'Drag & Drop',
    ),
    '/pages/gallery': RouteBreadcrumbModel(
      //title: 'Gallery',
      title: l.S.current.gallery,
      parentRoute: 'Pages',
      childRoute: 'Gallery',
    ),
    '/pages/maps': RouteBreadcrumbModel(
      //title: 'Maps',
      title: l.S.current.maps,
      parentRoute: 'Pages',
      childRoute: 'Maps',
    ),
    '/pages/pricing': RouteBreadcrumbModel(
      //title: 'Pricing',
      title: l.S.current.pricing,
      parentRoute: 'Pages',
      childRoute: 'Pricing',
    ),
    '/pages/tabs-and-pills': RouteBreadcrumbModel(
      // title: 'Tabs & Pills',
      title: l.S.current.tabsPills,
      parentRoute: 'Pages',
      childRoute: 'Tabs & Pills',
    ),
    '/pages/faqs': RouteBreadcrumbModel(
      //title: 'FAQs',
      title: l.S.current.fAQs,
      parentRoute: 'Pages',
      childRoute: 'FAQs',
    ),
    '/pages/404': RouteBreadcrumbModel(
      //title: '404',
      title: l.S.current.error,
      parentRoute: 'Pages',
      childRoute: '404',
    ),
    '/pages/privacy-policy': RouteBreadcrumbModel(
      // title: 'Privacy & Policy',
      title: l.S.current.privacyPolicy,
      parentRoute: 'Pages',
      childRoute: 'Privacy & Policy',
    ),
    '/pages/terms-conditions': RouteBreadcrumbModel(
      // title: 'Terms & Conditions',
      title: l.S.current.termsConditions,
      parentRoute: 'Pages',
      childRoute: 'Terms & Conditions',
    ),

    ///common role
    '/dashboard/base': RouteBreadcrumbModel(
      title: l.S.current.dashboard,
      parentRoute: 'Pages',
      childRoute: 'Base',
    ),

    ///for admin and super admin
    '/admin/business_setting': RouteBreadcrumbModel(
      title: l.S.current.business_setting,
      parentRoute: 'admin',
      childRoute: 'business_setting',
    ),
    '/admin/business_location': RouteBreadcrumbModel(
      title: l.S.current.business_location,
      parentRoute: 'admin',
      childRoute: 'business_location',
    ),

    '/master/milling-factory': RouteBreadcrumbModel(
      title: l.S.current.milling_factory,
      parentRoute: 'master',
      childRoute: 'milling-factory',
    ),
    '/master/product': RouteBreadcrumbModel(
      title: l.S.current.productList,
      parentRoute: 'master',
      childRoute: 'product',
    ),
    '/master/farmer': RouteBreadcrumbModel(
      title: l.S.current.farmer,
      parentRoute: 'master',
      childRoute: 'farmer',
    ),
    '/master/by-product': RouteBreadcrumbModel(
      title: l.S.current.by_product,
      parentRoute: 'master',
      childRoute: 'by-product',
    ),
    '/master/vehicle': RouteBreadcrumbModel(
      title: l.S.current.vehicle,
      parentRoute: 'master',
      childRoute: 'vehicle',
    ),
    '/master/vehicle-type': RouteBreadcrumbModel(
      title: l.S.current.vehicle_type,
      parentRoute: 'master',
      childRoute: 'vehicle-type',
    ),
    '/master/timezones': RouteBreadcrumbModel(
      title: l.S.current.timezone,
      parentRoute: 'master',
      childRoute: 'timezones',
    ),
    '/master/uoms': RouteBreadcrumbModel(
      title: l.S.current.uom,
      parentRoute: 'master',
      childRoute: 'uoms',
    ),
    '/master/gallery': RouteBreadcrumbModel(
      //title: 'Gallery',
      title: l.S.current.gallery,
      parentRoute: 'master',
      childRoute: 'gallery',
    ),

    ///for factory admin
    '/factory-admin/approved': RouteBreadcrumbModel(
      title: l.S.current.approved_stage,
      parentRoute: 'factory-admin',
      childRoute: 'approved',
    ),
    '/factory-admin/storage': RouteBreadcrumbModel(
      title: l.S.current.storage_stage,
      parentRoute: 'factory-admin',
      childRoute: 'storage',
    ),
    '/factory-admin/delivery': RouteBreadcrumbModel(
      title: l.S.current.delivery_stage,
      parentRoute: 'factory-admin',
      childRoute: 'delivery',
    ),

    ///for reporting
    '/storage/report': RouteBreadcrumbModel(
      title: l.S.current.storage_report,
      parentRoute: 'storage',
      childRoute: 'report',
    ),

    ///for factory supervisor
    '/stage/registering': RouteBreadcrumbModel(
      title: l.S.current.registering_stage,
      parentRoute: 'stage',
      childRoute: 'registering',
    ),
    '/stage/staff-qc': RouteBreadcrumbModel(
      title: l.S.current.staff_qc_stage,
      parentRoute: 'stage',
      childRoute: 'staff-qc',
    ),
    '/stage/input': RouteBreadcrumbModel(
      title: l.S.current.input_stage,
      parentRoute: 'stage',
      childRoute: 'input',
    ),
    '/stage/cleaning': RouteBreadcrumbModel(
      title: l.S.current.cleaning_stage,
      parentRoute: 'stage',
      childRoute: 'cleaning',
    ),
    '/stage/drying': RouteBreadcrumbModel(
      title: l.S.current.drying_stage,
      parentRoute: 'stage',
      childRoute: 'drying',
    ),

    '/stage/husking': RouteBreadcrumbModel(
      title: l.S.current.husking_stage,
      parentRoute: 'stage',
      childRoute: 'husking',
    ),
    '/stage/milling': RouteBreadcrumbModel(
      title: l.S.current.milling_stage,
      parentRoute: 'stage',
      childRoute: 'milling',
    ),
    '/stage/stoning': RouteBreadcrumbModel(
      title: l.S.current.stoning_stage,
      parentRoute: 'stage',
      childRoute: 'stoning',
    ),
    '/stage/polishing': RouteBreadcrumbModel(
      title: l.S.current.polishing_stage,
      parentRoute: 'stage',
      childRoute: 'polishing',
    ),
    '/stage/seiving': RouteBreadcrumbModel(
      title: l.S.current.seiving_stage,
      parentRoute: 'stage',
      childRoute: 'seiving',
    ),
    '/stage/sortex': RouteBreadcrumbModel(
      title: l.S.current.sortex_stage,
      parentRoute: 'stage',
      childRoute: 'sortex',
    ),
    '/stage/packaging': RouteBreadcrumbModel(
      title: l.S.current.stage_packaging,
      parentRoute: 'stage',
      childRoute: 'packaging',
    ),

    '/frk/frk_input': RouteBreadcrumbModel(
      title: l.S.current.frk_input_stage,
      parentRoute: 'frk',
      childRoute: 'frk_input',
    ),
    '/frk/frk_processing': RouteBreadcrumbModel(
      title: l.S.current.frk_pre_processing_stage,
      parentRoute: 'frk',
      childRoute: 'frk_processing',
    ),
    '/frk/frk_pulverizing': RouteBreadcrumbModel(
      title: l.S.current.frk_pulverizing_stage,
      parentRoute: 'frk',
      childRoute: 'frk_pulverizing',
    ),
    '/frk/frk_extrusion': RouteBreadcrumbModel(
      title: l.S.current.frk_extrusion_stage,
      parentRoute: 'frk',
      childRoute: 'frk_extrusion',
    ),
    '/frk/frk_packaging': RouteBreadcrumbModel(
      title: l.S.current.frk_packaging_stage,
      parentRoute: 'frk',
      childRoute: 'frk_packaging',
    ),
    '/frk/frk_qc': RouteBreadcrumbModel(
      title: l.S.current.frk_qc_stage,
      parentRoute: 'frk',
      childRoute: 'frk_qc',
    ),
    '/frk/frk_delivery': RouteBreadcrumbModel(
      title: l.S.current.frk_delivery_stage,
      parentRoute: 'frk',
      childRoute: 'frk_delivery',
    ),
    '/frk/frk_waste_mgmt': RouteBreadcrumbModel(
      title: l.S.current.frk_manager_stage,
      parentRoute: 'frk',
      childRoute: 'frk_waste_mgmt',
    ),
    '/frk/frk_energy': RouteBreadcrumbModel(
      title: l.S.current.frk_energy_stage,
      parentRoute: 'frk',
      childRoute: 'frk_energy',
    ),
  };
}
