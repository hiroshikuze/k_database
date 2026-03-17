import { useState, useEffect } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";

interface Customer {
  id: number;
  companyName: string;
  companyNameKana: string;
  department: string;
  branch: string;
  contactName: string;
  contactNameKana: string;
  tel: string;
  fax: string;
  email: string;
  postalCode: string;
  address: string;
  postalCode2: string;
  address2: string;
  website: string;
  status: string;
  region: string;
  industry: string;
  businessType: string;
  employeeCount: string;
  manager: string;
  note: string;
  createdAt: string;
  updatedAt: string;
}

interface HistoryItem {
  id: number;
  managerName: string;
  interactionType: string;
  occurredAt: string;
  content: string;
  createdAt: string;
}

const styles = {
  section: {
    background: "#fff",
    borderRadius: 6,
    padding: 16,
    marginBottom: 16,
    border: "1px solid #e2e8f0",
  } as const,
  sectionTitle: {
    fontWeight: "bold",
    fontSize: 14,
    marginBottom: 12,
    color: "#1e3a5f",
    borderBottom: "2px solid #e2e8f0",
    paddingBottom: 6,
  } as const,
  grid: {
    display: "grid",
    gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
    gap: "8px 16px",
  } as const,
  field: { display: "flex", flexDirection: "column" as const, gap: 2 } as const,
  label: { fontSize: 11, color: "#9ca3af", fontWeight: "bold" } as const,
  value: { fontSize: 13 } as const,
  toolbar: { display: "flex", gap: 8, marginBottom: 16, alignItems: "center" } as const,
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
    padding: "6px 14px",
  } as const,
  historyItem: {
    borderBottom: "1px solid #e2e8f0",
    paddingBottom: 12,
    marginBottom: 12,
  } as const,
  historyMeta: { fontSize: 12, color: "#6b7280", marginBottom: 4 } as const,
  addHistoryForm: {
    display: "grid",
    gridTemplateColumns: "1fr 1fr",
    gap: 8,
    marginTop: 12,
  } as const,
  input: {
    border: "1px solid #d1d5db",
    borderRadius: 4,
    padding: "6px 8px",
    width: "100%",
  } as const,
};

function Field({ label, value }: { label: string; value?: string | null }) {
  if (!value) return null;
  return (
    <div style={styles.field}>
      <span style={styles.label}>{label}</span>
      <span style={styles.value}>{value}</span>
    </div>
  );
}

export default function CustomerDetail() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [histories, setHistories] = useState<HistoryItem[]>([]);
  const [newHistory, setNewHistory] = useState({
    managerName: "",
    interactionType: "電話",
    occurredAt: new Date().toISOString().slice(0, 16).replace("T", " "),
    content: "",
  });

  useEffect(() => {
    window.fetch(`/api/customers/${id}`)
      .then((r) => r.json())
      .then(setCustomer);
    window.fetch(`/api/history/customer/${id}`)
      .then((r) => r.json())
      .then(setHistories);
  }, [id]);

  const handleDelete = async () => {
    if (!confirm(`「${customer?.companyName}」を削除しますか？`)) return;
    await window.fetch(`/api/customers/${id}`, { method: "DELETE" });
    navigate("/customers");
  };

  const handleAddHistory = async () => {
    if (!newHistory.content.trim()) return;
    const res = await window.fetch("/api/history", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ...newHistory, customerId: Number(id) }),
    });
    const added = await res.json();
    setHistories([added, ...histories]);
    setNewHistory({ ...newHistory, content: "" });
  };

  const handleDeleteHistory = async (historyId: number) => {
    if (!confirm("この履歴を削除しますか？")) return;
    await window.fetch(`/api/history/${historyId}`, { method: "DELETE" });
    setHistories(histories.filter((h) => h.id !== historyId));
  };

  if (!customer) return <p style={{ color: "#9ca3af" }}>読み込み中...</p>;

  return (
    <div>
      <div style={styles.toolbar}>
        <Link to="/customers">← 一覧に戻る</Link>
        <Link to={`/customers/${id}/edit`} style={{ marginLeft: "auto" }}>
          <button style={styles.btn}>編集</button>
        </Link>
        <button style={styles.btnDanger} onClick={handleDelete}>
          削除
        </button>
      </div>

      <div style={styles.section}>
        <div style={styles.sectionTitle}>基本情報</div>
        <div style={styles.grid}>
          <Field label="会社名" value={customer.companyName} />
          <Field label="会社名（ふりがな）" value={customer.companyNameKana} />
          <Field label="部署" value={customer.department} />
          <Field label="支店" value={customer.branch} />
          <Field label="担当者" value={customer.contactName} />
          <Field label="担当者（ふりがな）" value={customer.contactNameKana} />
        </div>
      </div>

      <div style={styles.section}>
        <div style={styles.sectionTitle}>連絡先</div>
        <div style={styles.grid}>
          <Field label="TEL" value={customer.tel} />
          <Field label="FAX" value={customer.fax} />
          <Field label="メール" value={customer.email} />
          <Field label="Web" value={customer.website} />
          <Field label="郵便番号" value={customer.postalCode} />
          <Field label="住所" value={customer.address} />
          {customer.postalCode2 && (
            <>
              <Field label="郵便番号2" value={customer.postalCode2} />
              <Field label="住所2" value={customer.address2} />
            </>
          )}
        </div>
      </div>

      <div style={styles.section}>
        <div style={styles.sectionTitle}>属性</div>
        <div style={styles.grid}>
          <Field label="状態" value={customer.status} />
          <Field label="地域" value={customer.region} />
          <Field label="業種" value={customer.industry} />
          <Field label="業態" value={customer.businessType} />
          <Field label="従業員数" value={customer.employeeCount} />
          <Field label="担当者" value={customer.manager} />
        </div>
      </div>

      {customer.note && (
        <div style={styles.section}>
          <div style={styles.sectionTitle}>備考</div>
          <p style={{ fontSize: 13, whiteSpace: "pre-wrap" }}>{customer.note}</p>
        </div>
      )}

      <div style={styles.section}>
        <div style={styles.sectionTitle}>対応履歴</div>

        {/* 履歴追加フォーム */}
        <div style={styles.addHistoryForm}>
          <input
            style={styles.input}
            placeholder="担当者名"
            value={newHistory.managerName}
            onChange={(e) => setNewHistory({ ...newHistory, managerName: e.target.value })}
          />
          <select
            style={styles.input}
            value={newHistory.interactionType}
            onChange={(e) => setNewHistory({ ...newHistory, interactionType: e.target.value })}
          >
            {["電話", "メール", "訪問", "FAX", "その他"].map((t) => (
              <option key={t}>{t}</option>
            ))}
          </select>
          <input
            style={styles.input}
            type="datetime-local"
            value={newHistory.occurredAt.replace(" ", "T")}
            onChange={(e) =>
              setNewHistory({ ...newHistory, occurredAt: e.target.value.replace("T", " ") })
            }
          />
          <button style={styles.btn} onClick={handleAddHistory}>
            追加
          </button>
          <textarea
            style={{ ...styles.input, gridColumn: "1 / -1", height: 80, resize: "vertical" }}
            placeholder="対応内容"
            value={newHistory.content}
            onChange={(e) => setNewHistory({ ...newHistory, content: e.target.value })}
          />
        </div>

        {/* 履歴一覧 */}
        <div style={{ marginTop: 16 }}>
          {histories.length === 0 ? (
            <p style={{ color: "#9ca3af", fontSize: 13 }}>履歴がありません</p>
          ) : (
            histories.map((h) => (
              <div key={h.id} style={styles.historyItem}>
                <div style={styles.historyMeta}>
                  <strong>{h.interactionType}</strong>　{h.occurredAt}　{h.managerName}
                  <button
                    style={{
                      marginLeft: 12,
                      background: "none",
                      border: "none",
                      color: "#dc2626",
                      fontSize: 12,
                      cursor: "pointer",
                    }}
                    onClick={() => handleDeleteHistory(h.id)}
                  >
                    削除
                  </button>
                </div>
                <p style={{ fontSize: 13, whiteSpace: "pre-wrap" }}>{h.content}</p>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
