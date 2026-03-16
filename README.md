# k_database — Customer Management Database

A lightweight, web-based customer relationship management (CRM) system written in Perl. Runs as a CGI application with no external database required — all data is stored in plain tab-delimited CSV files.

> **Current version**: 0.902D (last updated March 6, 2005)

[![Japanese Documentation](https://img.shields.io/badge/docs-日本語ドキュメント-blue?style=for-the-badge&logo=readme)](https://hiroshikuze.github.io/k_database/)

---

## Features

- **Web-based groupware** — accessible by multiple users through a browser. Only a Perl runtime is required; no additional modules needed.
- **Customer records** — store and manage detailed customer information including company name, address, phone, fax, email, website, industry, region, and more.
- **Correspondence history** — log and track interactions with each customer. Adding and deleting records is restricted to administrators; all users can view and edit.
- **Full-text search** — search across both customer records and correspondence history.
- **CSV data storage** — all data is saved as tab-delimited text files, making it easy to integrate with other tools.
- **Excel export** — administrators can open the data list directly in Excel from the browser (requires IE + Excel).
- **Bulk email** — administrators can send a single email to all registered companies at once (requires sendmail or compatible MTA).
- **MapFan integration** — addresses in the customer list automatically link to MapFan web maps.
- **Automatic backups** — a one-generation backup file is created automatically whenever data is added or edited.
- **Admin notice board** — a message from the administrator can be displayed on the top page, useful for broadcasting notices to all users.
- **Customizable layout** — the surrounding UI can be customized by editing the bottom section of `src/output_sub.pl`.
- **Operation audit log** — a partial history of operations is recorded for security purposes.
- **Renamed entry point** — the `index.cgi` filename can be changed to improve security through obscurity.
- **Free to use and redistribute** — installation and setup services may be charged separately.

## Limitations

- **Fixed schema** — adding or renaming data fields requires code changes and is not straightforward.
- **Text only** — binary files such as photos cannot be stored.
- **Desktop browser only** — designed for PC use; mobile and PDA browsers are not supported.
- **Minimal active support** — this is a personal project; bug fixes and new features may be slow.

---

## Requirements

- A web server with CGI support (Apache, etc.)
- Perl 5 (no additional CPAN modules required)
- Write permission on the `src/` directory for the web server user (needed for CSV and backup files)
- sendmail or a compatible MTA (only for the bulk email feature)
- Internet Explorer + Microsoft Excel (only for the Excel export feature)

---

## Deployment

1. Copy the contents of the `src/` directory to a CGI-enabled directory on your web server.
2. Set execute permissions on the CGI entry points:
   ```bash
   chmod 755 index.cgi downdata.cgi dummy.cgi
   ```
3. Ensure the web server user has write access to the CSV and backup files:
   ```bash
   chmod 666 kokyaku.csv taiou.csv sousa_rireki.csv
   ```
4. Open `index.cgi` in a browser to start using the application.

---

## Repository Structure

```
k_database/
├── src/       # Deployable application — copy this to your web server
├── docs/      # Original Japanese documentation (HTML)
├── README.md
└── LICENCE.md
```

See [CLAUDE.md](CLAUDE.md) for a full breakdown of the source file roles and architecture.

---

## Security Note

Versions **0.900E and earlier** contain a critical security vulnerability: HTTP_REFERER leaks the database URL and a weakly-protected admin password when a user clicks an external link. This was fixed in **ver 0.900F**. If you are running an older version, please upgrade.

---

## Author

[hiroshikuze](https://github.com/hiroshikuze)

## 💖 Support my work

If you'd like to support my projects, please consider becoming a sponsor!

[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-GitHub%20Sponsors-ea4aaa?style=for-the-badge&logo=github-sponsors)](https://github.com/sponsors/hiroshikuze)

[Author's wish list by Amazon (Japanese)](https://www.amazon.jp/hz/wishlist/ls/5BAWD0LZ89V9?ref_=wl_share)
