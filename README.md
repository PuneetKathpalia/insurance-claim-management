# Insurance Claim Management System

A Flutter Web application for managing insurance claims at hospitals.

## Features

- **Dashboard**: View all insurance claims with quick statistics
- **Create/Edit Claims**: Add patient information, bills, and advance amounts
- **Claim Details**: View complete claim information with bill breakdown
- **Status Management**: Track claim status through the workflow (Draft → Submitted → Approved → Rejected/Partially Settled)
- **Settlement Tracking**: Record settlement amounts with automatic pending calculations
- **Clean UI**: Professional Material Design interface

## Project Structure

```
lib/
  main.dart                 # App entry point
  models/
    bill.dart              # Bill model
    claim.dart             # Claim model with status enum
  screens/
    dashboard_screen.dart  # Main dashboard with claim list
    claim_form_screen.dart # Create/edit claim form
    claim_detail_screen.dart # View claim details
  widgets/
    bill_list_widget.dart  # Reusable bill list component
    status_chip.dart       # Status badge component
  services/
    claim_service.dart     # Claim data service with ChangeNotifier
```

## Setup Instructions

### Prerequisites
- Flutter SDK (latest stable - 3.0+)
- Chrome browser (for web development)

### Installation

1. **Install Flutter** (if not already installed)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **Navigate to project directory**
   ```
   cd insurance_claim_management
   ```

3. **Get dependencies**
   ```
   flutter pub get
   ```

4. **Run the application**
   ```
   flutter run -d chrome
   ```

5. **Build for production**
   ```
   flutter build web
   ```

## Claim Status Workflow

- **Draft**: Initial state, can be edited
- **Submitted**: Ready for review
- **Approved**: Claim accepted, ready for settlement
- **Rejected**: Claim denied (terminal state)
- **Partially Settled**: Settlement amount received, still pending

## Key Features

### Dashboard
- Lists all claims with quick stats
- Shows patient name, status, total bill, and pending amount
- Floating action button to create new claims
- Click any claim to view details

### Claim Form
- Patient name input (required)
- Dynamic bill management (add/edit/delete)
- Advance amount tracking
- Save as Draft or Submit Claim
- Validation for required fields

### Claim Details
- Complete claim information display
- Bill list with amounts
- Automatic pending amount calculation
- Settlement amount input (for approved claims)
- Status transition buttons based on current status
- Edit and delete options

## Calculations

- **Total Bills** = Sum of all bill amounts
- **Pending Amount** = Total Bills - Advance Amount - Settlement Amount
- All calculations update automatically

## Technologies Used

- Flutter 3.0+
- Material UI
- ChangeNotifier for state management
- Local in-memory data storage

## Notes

- No backend integration - all data stored locally
- Single-user application suitable for admin dashboards
- Clean, readable code without unnecessary abstractions
- Interview-ready codebase
