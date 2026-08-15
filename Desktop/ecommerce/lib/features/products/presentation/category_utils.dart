/// lib/utils/category_utils.dart
///
/// Small shared helper so category formatting lives in one place
/// instead of being copy-pasted across screens.
String readableCategory(String category) {
  switch (category) {
    case 'men clothing':
      return "Men's Clothing";
    case 'women clothing':
      return "Women's Clothing";
    case 'jewelery':
      return 'Jewelery';
    case 'electronics':
      return 'Electronics';
    default:
      return category
          .split(' ')
          .map((word) =>
              word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
          .join(' ');
  }
}

/// Responsive helpers -------------------------------------------------

/// Number of grid columns for the product grid, based on available width.
int gridColumnsForWidth(double width) {
  if (width >= 1200) return 5;
  if (width >= 900) return 4;
  if (width >= 600) return 3;
  return 2;
}

/// Aspect ratio for product cards, tuned per column count so cards don't
/// get too tall/narrow as columns increase.
double gridAspectRatioForColumns(int columns) {
  switch (columns) {
    case 5:
      return 0.72;
    case 4:
      return 0.68;
    case 3:
      return 0.66;
    default:
      return 0.62;
  }
}

/// Whether the current width should be treated as a "wide" (tablet/desktop)
/// layout, e.g. side-by-side detail screens, centered constrained content.
bool isWideScreen(double width) => width >= 720;

/// Max content width so text/lists don't stretch edge-to-edge on very
/// wide screens (web/desktop/tablet landscape).
const double kMaxContentWidth = 1100;
