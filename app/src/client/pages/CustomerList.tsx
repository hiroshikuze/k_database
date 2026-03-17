import { useState, useEffect, useCallback } from "react";
import { Link, useSearchParams } from "react-router-dom";

interface Customer {
  id: number;
  companyName: string;
  companyNameKana: string;
  contactName: string;
  tel: string;
  email: string;
  status: string;
  region: string;
}

interface ApiResponse {
  data: Customer[];
  total: number;
  page: number;
  limit: number;
}

const styles = {
  toolbar: {
    display: "flex",
    gap: 8,
    marginBottom: 12,
    alignItems: "center",
  } as const,
  searchInput: {
    border: "1px solid #d1d5db",
    borderRadius: 4,
    padding: "6px 10px",
    width: 240,
    outline: "none",
  } as const,
  btn: {
    background: "#2563eb",
    color: "#fff",
    border: "none",
    borderRadius: 4,
    padding: "6px 14px",
  } as const,
  btnDanger: {
    background: "#dc2626",
    color: "#fff",
    border: "none",
    borderRadius: 4,
    padding: "4px 10px",
    fontSize: 12,
  } as const,
  table: {
    width: "100%",
    borderCollapse: "collapse" as const,
    background: "#fff",
    fontSize: 13,
  },
  th: {
    background: "#f1f5f9",
    borderBottom: "2px solid #e2e8f0",
    padding: "8px 10px",
    textAlign: "left" as const,
    fontWeight: "bold",
    whiteSpace: "nowrap" as const,
  },
  td: {
    borderBottom: "1px solid #e2e8f0",
    padding: "8px 10px",
    verticalAlign: "top" as const,
  },
  pager: {
    display: "flex",
    gap: 8,
    marginTop: 12,
    alignItems: "center",
    justifyContent: "flex-end",
  } as const,
  pagerBtn: {
    border: "1px solid #d1d5db",
    borderRadius: 4,
    padding: "4px 10px",
    background: "#fff",
  } as const,
};

const PAGE_LIMIT = 30;

export default function CustomerList() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [result, setResult] = useState<ApiResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [searchInput, setSearchInput] = useState(searchParams.get("q") ?? "");

  const q = searchParams.get("q") ?? "";
  const page = parseInt(searchParams.get("page") ?? "1");

  const fetch = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({ page: String(page), limit: String(PAGE_LIMIT) });
      if (q) params.set("q", q);
      const res = await window.fetch(`/api/customers?${params}`);
      setResult(await res.json());
    } finally {
      setLoading(false);
    }
  }, [q, page]);

  useEffect(() => { fetch(); }, [fetch]);

  const handleSearch = () => {
    setSearchParams(searchInput ? { q: searchInput, page: "1" } : { page: "1" });
  };

  const handleDelete = async (id: number, name: string) => {
    if (!confirm(`「${name}」を削除しますか？`)) return;
    await window.fetch(`/api/customers/${id}`, { method: "DELETE" });
    fetch();
  };

  const totalPages = result ? Math.ceil(result.total / PAGE_LIMIT) : 1;

  return (
    <div>
      <div style={styles.toolbar}>
        <input
          style={styles.searchInput}
          placeholder="会社名・担当者・TEL・メール・住所"
          value={searchInput}
          onChange={(e) => setSearchInput(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && handleSearch()}
        />
        <button style={styles.btn} onClick={handleSearch}>
          検索
        </button>
        {q && (
          <button
            style={{ ...styles.btn, background: "#6b7280" }}
            onClick={() => { setSearchInput(""); setSearchParams({ page: "1" }); }}
          >
            クリア
          </button>
        )}
        <span style={{ marginLeft: "auto", color: "#6b7280" }}>
          {result ? `${result.total}件` : ""}
        </span>
        <Link to="/customers/new">
          <button style={styles.btn}>＋ 新規登録</button>
        </Link>
      </div>

      {loading && <p style={{ color: "#6b7280" }}>読み込み中...</p>}

      {result && (
        <>
          <table style={styles.table}>
            <thead>
              <tr>
                <th style={styles.th}>会社名</th>
                <th style={styles.th}>担当者</th>
                <th style={styles.th}>TEL</th>
                <th style={styles.th}>メール</th>
                <th style={styles.th}>地域</th>
                <th style={styles.th}>状態</th>
                <th style={styles.th}></th>
              </tr>
            </thead>
            <tbody>
              {result.data.length === 0 ? (
                <tr>
                  <td colSpan={7} style={{ ...styles.td, textAlign: "center", color: "#9ca3af" }}>
                    データがありません
                  </td>
                </tr>
              ) : (
                result.data.map((c) => (
                  <tr key={c.id}>
                    <td style={styles.td}>
                      <Link to={`/customers/${c.id}`}>{c.companyName || "（未設定）"}</Link>
                      {c.companyNameKana && (
                        <div style={{ fontSize: 11, color: "#9ca3af" }}>{c.companyNameKana}</div>
                      )}
                    </td>
                    <td style={styles.td}>{c.contactName}</td>
                    <td style={styles.td}>{c.tel}</td>
                    <td style={styles.td}>{c.email}</td>
                    <td style={styles.td}>{c.region}</td>
                    <td style={styles.td}>{c.status}</td>
                    <td style={{ ...styles.td, whiteSpace: "nowrap" }}>
                      <Link to={`/customers/${c.id}/edit`}>
                        <button style={{ ...styles.pagerBtn, marginRight: 4, fontSize: 12 }}>編集</button>
                      </Link>
                      <button
                        style={styles.btnDanger}
                        onClick={() => handleDelete(c.id, c.companyName)}
                      >
                        削除
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>

          {totalPages > 1 && (
            <div style={styles.pager}>
              <button
                style={styles.pagerBtn}
                disabled={page <= 1}
                onClick={() => setSearchParams({ ...(q ? { q } : {}), page: String(page - 1) })}
              >
                ← 前へ
              </button>
              <span style={{ fontSize: 13, color: "#6b7280" }}>
                {page} / {totalPages}
              </span>
              <button
                style={styles.pagerBtn}
                disabled={page >= totalPages}
                onClick={() => setSearchParams({ ...(q ? { q } : {}), page: String(page + 1) })}
              >
                次へ →
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}
