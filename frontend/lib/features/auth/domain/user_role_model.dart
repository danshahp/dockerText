/// Defines the different roles a user can have within the BMS.
enum UserRole {
  admin,      // Full access, system configuration
  manager,    // Oversees operations, manages staff, views comprehensive reports
  accountant, // Manages finances, taxes, payroll, financial reports
  cashier,    // Handles sales, payments, basic inventory checks
  staff,      // General staff, may have specific limited permissions (e.g., inventory updates)
  customer,   // For potential B2C interactions or portal access (future)
  undefined   // Default role or for users whose role is not yet set
}

// Helper extension for UserRole (optional, but can be useful)
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin: return 'Admin';
      case UserRole.manager: return 'Manager';
      case UserRole.accountant: return 'Accountant';
      case UserRole.cashier: return 'Cashier';
      case UserRole.staff: return 'Staff';
      case UserRole.customer: return 'Customer';
      case UserRole.undefined: return 'Undefined';
      // No default needed as all enum values are covered.
    }
  }

  // You can add more properties or methods here, e.g., for permissions checking
  List<String> getPermissions() {
    // This is a placeholder. In a real app, permissions would be more granular
    // and potentially fetched from a backend or configuration.
    switch (this) {
      case UserRole.admin:
        return ['manage_users', 'manage_settings', 'view_all_reports', 'manage_inventory', 'manage_sales', 'manage_payroll'];
      case UserRole.manager:
        return ['manage_staff', 'view_reports', 'manage_inventory_basic', 'manage_sales_overview'];
      case UserRole.accountant:
        return ['manage_finances', 'manage_taxes', 'process_payroll', 'view_financial_reports'];
      case UserRole.cashier:
        return ['process_sales', 'manage_payments', 'view_basic_stock'];
      case UserRole.staff:
        return ['update_inventory', 'view_assigned_tasks'];
      case UserRole.customer:
        return ['view_orders', 'update_profile'];
      case UserRole.undefined:
        return [];
      // No default needed as all enum values are covered.
    }
  }
}
