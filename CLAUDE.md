# CLAUDE.md — AI Assistant Guide for k_database

This document describes the structure, conventions, and workflows for the **k_database** repository, intended for AI assistants and developers working on this codebase.

---

## Project Overview

**k_database** is a lightweight, CGI-based Customer Relationship Management (CRM) system written in Perl. It targets small organizations managing customer data and interaction histories. The UI and internal comments are primarily in **Japanese**.

- **Language**: Perl 5 (procedural, no OOP)
- **Architecture**: CGI web application (no framework)
- **Data Storage**: Flat CSV files (no SQL database)
- **Character Encoding**: EUC-JP (with conversion utilities for JIS/SJIS)
- **Author**: hiroshikuze
- **License**: Custom (see LICENCE.md) — free to use/modify with attribution

---

## Repository Structure

```
k_database/
├── .gitignore              # Excludes runtime-generated *.bak files
├── README.md               # Short project description
├── LICENCE.md              # License terms (Japanese)
├── CLAUDE.md               # This file — AI assistant guide
├── docs/                   # Standalone documentation (not loaded by the app)
│   ├── readme.html         # Main user guide (Japanese)
│   ├── info_program.html   # Program structure documentation (Japanese)
│   ├── info_use.html       # Usage manual (Japanese)
│   ├── info_supports.html  # Support and copyright information (Japanese)
│   └── info_program.gif    # Screenshot used in documentation
└── src/                    # Deployable application — also served as GitHub Pages
    ├── index.html          # Japanese documentation (GitHub Pages top page)
    ├── index.cgi           # Main CGI entry point — all request routing
    ├── downdata.cgi        # Excel/CSV data export
    ├── dummy.cgi           # HTTP referrer security validation
    ├── config.dat          # Binary (Perl serialized) configuration
    ├── kokyaku.csv         # Customer master database (tab-delimited, header only)
    ├── taiou.csv           # Interaction/correspondence log (header only)
    ├── sousa_rireki.csv    # Operation audit trail
    ├── favicon.ico         # Browser tab icon
    ├── *.gif               # UI icons (icon_*.gif) and documentation screenshots (image*.gif)
    └── *.pl                # All Perl library modules and feature subroutines (flat)
```

> **Note**: `*.bak` files are runtime-generated backups — excluded from the repository via `.gitignore`.
> All `*.pl` files are kept flat within `src/` so that `require 'lib.pl'` statements in the CGI scripts resolve correctly without any path changes.

---

## Source File Roles

### Entry Points

| File | Purpose |
|------|---------|
| `index.cgi` | Main controller. Uses `$sw` state variable to route between screens. |
| `downdata.cgi` | Exports customer data as tab-delimited file for Excel. |
| `dummy.cgi` | Validates HTTP_REFERER and blocks unauthorized direct access. |

### Core Library Modules (`*_lib.pl`)

| File | Purpose |
|------|---------|
| `form_lib.pl` | Parses CGI POST/GET form data into `%form` hash; strips HTML tags |
| `jcode.pl` | Japanese character encoding conversion (EUC/JIS/SJIS) — third-party |
| `file_access_lib.pl` | CSV file I/O with `flock`-based locking |
| `output_sub.pl` | HTML output helpers and page templates |
| `options_lib.pl` | Builds `<select>` dropdown option lists for forms |
| `tab_cut_lib.pl` | Splits tab-delimited CSV lines into `@cut_end` array |
| `debug_lib.pl` | Debug logging to file |
| `encodesubject_lib.pl` | RFC2047 BASE64 encoding for email subject headers |
| `seiri_formdata_lib.pl` | Normalizes and cleans form input data |
| `save_kanri_rireki_lib.pl` | Records management/audit history entries |

### Feature Modules

| Feature Area | Files |
|-------------|-------|
| Customer search | `search_sub.pl` |
| Customer edit | `edit_check_sub.pl`, `edit_save_sub.pl`, `edit_rireki_sub.pl` |
| Customer detail view | `syousai_sub.pl`, `html_syousai0_sub.pl`, `html_syousai1_sub.pl`, `html_syousai2_sub.pl` |
| Interaction history | `save_rireki_sub.pl`, `html_check_sousarireki_sub.pl` |
| Email | `edit_sendmail_naiyou_sub.pl`, `edit_sendmail_send_sub.pl`, `html_mail_kakunin_sub.pl`, `html_mail_naiyou_sub.pl` |
| Admin/settings | `master_edit_info_sub.pl`, `master_check_edit_sub.pl`, `master_setting_change_sub.pl`, `master_switch_sub.pl`, `html_kanrimode_switch_sub.pl` |

### File Naming Conventions

- `html_*_sub.pl` — HTML rendering/output for a specific screen
- `edit_*_sub.pl` — Data editing and save operations
- `master_*_sub.pl` — Administrative / settings functions
- `*_lib.pl` — Reusable utility libraries
- `*_rireki*` — History or audit trail related logic

---

## Data Model (CSV Schema)

### `kokyaku.csv` — Customer Master (~33 tab-separated fields)

Key fields (positional, tab-delimited, no header row in data):
- Customer ID, Classification, Company name, Company name (furigana)
- Department, Division, Postal code, Address
- Phone, Fax, Email, Website
- Employee count, Industry category, Region, Status

### `taiou.csv` — Interaction/Correspondence Log (~6-7 fields)

- Management ID, Customer ID, Customer name
- Manager name, Interaction type, Date/time, Notes

### `sousa_rireki.csv` — Operation Audit Trail

Tracks create/update/delete operations on customer records.

**Important**: All data files use tab (`\t`) as delimiter, not commas. Backups are written automatically to `*.bak` files before any save operation.

---

## Architecture Patterns

### Request Routing

`index.cgi` uses a `$sw` (switch) variable as a state machine. Each state value maps to a screen or action:

```perl
# Pattern used throughout index.cgi
if ($sw eq "some_state") {
    require "./some_sub.pl";
    &some_subroutine();
}
```

### Form Handling

Form data is parsed by `form_lib.pl` into the global `%form` hash:

```perl
require "./form_lib.pl";
&form_parse();  # populates %form
$form{'fieldname'}  # access a field
```

### File I/O

All CSV access goes through `file_access_lib.pl` with file locking:

```perl
require "./file_access_lib.pl";
&file_access("<$filename", $error_code);   # read
&file_access(">$filename", $error_code);   # write (truncate)
```

### Tab-Delimited Parsing

After reading a CSV line, parse fields with `tab_cut_lib.pl`:

```perl
require "./tab_cut_lib.pl";
&tab_cut($line);        # populates @cut_end array
$cut_end[0]             # first field
$cut_end[1]             # second field, etc.
```

---

## Development Conventions

### Code Style

- Pure procedural Perl — no `use strict` or `use warnings` in older files
- All modules are loaded with `require` (not `use`), so they are loaded at runtime
- Global variables are heavily used — be careful of unintended side effects
- Japanese variable names and comments are common and expected
- Subroutines are defined as `sub funcname { ... }` without prototypes

### Character Encoding

- Source files and data use **EUC-JP** encoding
- `jcode.pl` handles conversion when needed
- When editing files, preserve the existing encoding — do not save as UTF-8 unless explicitly converting the project

### Security Considerations

- HTML input is sanitized in `form_lib.pl` to prevent XSS
- Admin mode is password-protected using `crypt()` with salt `"cr"`
- `dummy.cgi` validates `HTTP_REFERER` for some pages
- **No CSRF protection** — be aware when adding form-based actions
- The codebase is from 2002–2005; modern security practices should be applied if deploying publicly

### No Build Step

This is a pure CGI script application — no compilation, no bundler, no transpiler. To deploy:
1. Copy the entire `src/` directory contents to a CGI-enabled web directory
2. Set execute permissions on `*.cgi` files (`chmod 755`)
3. Ensure the web server user has write access to `*.csv` and `*.bak` files

---

## No Testing Infrastructure

There is **no automated test suite**. All verification is manual:

- No test files or test directories exist
- No testing framework is configured
- When making changes, test by running the CGI scripts in a web server environment

If adding tests, consider using `Test::More` (standard Perl testing) with mock CGI environments.

---

## Configuration

`config.dat` is a Perl serialized binary file. It stores:
- Character encoding preference
- Pagination settings (items per page)
- Sendmail/SMTP configuration
- Admin password (crypt-hashed)

**Do not edit `config.dat` directly as a text file.** Modify it through the admin UI or by writing a Perl script that uses `Storable` or similar to deserialize/reserialize.

---

## Key Workflows

### Adding a New Screen

1. Create `html_newscreen_sub.pl` for HTML output
2. Create `newscreen_sub.pl` for business logic (if needed)
3. Add a new `$sw` state handler in `index.cgi`
4. Add form links pointing to the new `$sw` value

### Modifying Customer Fields

1. Update `kokyaku.csv` schema (add/remove tab-delimited columns)
2. Update `tab_cut_lib.pl` or the calling code to reference new column indices
3. Update all `html_syousai*.pl` and `edit_*.pl` files that render/save this data
4. Update `options_lib.pl` if any dropdowns are affected

### Adding Email Functionality

1. Business logic goes in `edit_sendmail_*.pl`
2. Email subjects must be RFC2047 encoded using `encodesubject_lib.pl`
3. Use the system's `sendmail` binary (path may be configured in `config.dat`)

---

## External Integrations

- **MapFan Web API**: Optional address/location lookup (referenced in documentation)
- **Microsoft Excel**: Data export via `downdata.cgi` produces tab-delimited files readable by Excel
- **Sendmail/SMTP**: Email sending through system MTA

---

## Important Notes for AI Assistants

1. **Repository layout** — source is in `src/`, docs in `docs/`. When editing or creating files, place them in the correct directory
2. **Japanese content is expected** — do not replace Japanese strings with English unless the user explicitly asks
3. **EUC-JP encoding** — be careful when modifying files that contain Japanese characters
4. **No tests exist** — do not assume correctness without manual verification
5. **Global state** — modifying shared variables (e.g., `%form`, `@cut_end`) affects the whole request
6. **File locking is critical** — always use `file_access_lib.pl` for CSV I/O; direct file access bypasses locking and risks data corruption
7. **Backup files** — `*.bak` files are auto-generated and gitignored; do not commit them
8. **CGI environment** — code runs under a web server; `STDIN`, `STDOUT`, and environment variables like `QUERY_STRING` are the I/O channels
9. **Old Perl idioms** — the codebase uses pre-modern Perl patterns; prefer consistency with existing style over modernization unless asked
10. **`require` paths** — all `*.pl` files are flat in `src/`; do not move them into subdirectories without updating all `require` calls in `index.cgi`, `downdata.cgi`, `dummy.cgi`, and any other modules that load them
