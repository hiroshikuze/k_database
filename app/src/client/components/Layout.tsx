import { Link } from "react-router-dom";
import type { ReactNode } from "react";

const styles = {
  header: {
    background: "#1e3a5f",
    color: "#fff",
    padding: "0 16px",
    display: "flex",
    alignItems: "center",
    height: 48,
    gap: 24,
  } as const,
  title: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#fff",
    textDecoration: "none",
  } as const,
  nav: { display: "flex", gap: 16 } as const,
  navLink: {
    color: "#cbd5e1",
    fontSize: 13,
    textDecoration: "none",
  } as const,
  main: {
    maxWidth: 1200,
    margin: "0 auto",
    padding: "16px",
  } as const,
};

export default function Layout({ children }: { children: ReactNode }) {
  return (
    <>
      <header style={styles.header}>
        <Link to="/customers" style={styles.title}>
          顧客データベース
        </Link>
        <nav style={styles.nav}>
          <Link to="/customers" style={styles.navLink}>
            顧客一覧
          </Link>
          <Link to="/customers/new" style={styles.navLink}>
            新規登録
          </Link>
        </nav>
      </header>
      <main style={styles.main}>{children}</main>
    </>
  );
}
