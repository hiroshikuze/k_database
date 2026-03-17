import { useState, useEffect } from "react";
import { useParams, useNavigate, Link } from "react-router-dom";

type FormData = {
  classification: string;
  companyName: string;
  companyNameKana: string;
  department: string;
  departmentKana: string;
  branch: string;
  branchKana: string;
  branchDepartment: string;
  contactName: string;
  contactNameKana: string;
  postalCode: string;
  address: string;
  postalCode2: string;
  address2: string;
  tel: string;
  fax: string;
  email: string;
  establishedMonth: string;
  establishedYear: string;
  businessType: string;
  employeeCount: string;
  region: string;
  industry: string;
  mainProducts: string;
  privateName: string;
  website: string;
  manager: string;
  status: string;
  pcType: string;
  lanEnv: string;
  envContactName: string;
  note: string;
  displayFlag: boolean;
  mainCustomer: boolean;
};

const EMPTY_FORM: FormData = {
  classification: "",
  companyName: "",
  companyNameKana: "",
  department: "",
  departmentKana: "",
  branch: "",
  branchKana: "",
  branchDepartment: "",
  contactName: "",
  contactNameKana: "",
  postalCode: "",
  address: "",
  postalCode2: "",
  address2: "",
  tel: "",
  fax: "",
  email: "",
  establishedMonth: "",
  establishedYear: "",
  businessType: "",
  employeeCount: "",
  region: "",
  industry: "",
  mainProducts: "",
  privateName: "",
  website: "",
  manager: "",
  status: "",
  pcType: "",
  lanEnv: "",
  envContactName: "",
  note: "",
  displayFlag: true,
  mainCustomer: false,
};

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
    gap: "10px 16px",
  } as const,
  fieldGroup: { display: "flex", flexDirection: "column" as const, gap: 4 } as const,
  label: { fontSize: 12, color: "#6b7280", fontWeight: "bold" } as const,
  input: {
    border: "1px solid #d1d5db",
    borderRadius: 4,
    padding: "6px 8px",
    width: "100%",
  } as const,
  toolbar: { display: "flex", gap: 8, marginBottom: 16, alignItems: "center" } as const,
  btnPrimary: {
    background: "#2563eb",
    color: "#fff",
    border: "none",
    borderRadius: 4,
    padding: "8px 20px",
    fontWeight: "bold",
  } as const,
  btnSecondary: {
    background: "#fff",
    color: "#374151",
    border: "1px solid #d1d5db",
    borderRadius: 4,
    padding: "8px 16px",
  } as const,
};

function Field({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div style={styles.fieldGroup}>
      <label style={styles.label}>{label}</label>
      {children}
    </div>
  );
}

export default function CustomerForm() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isEdit = !!id;
  const [form, setForm] = useState<FormData>(EMPTY_FORM);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (!isEdit) return;
    window.fetch(`/api/customers/${id}`)
      .then((r) => r.json())
      .then((data) =>
        setForm({
          classification: data.classification ?? "",
          companyName: data.companyName ?? "",
          companyNameKana: data.companyNameKana ?? "",
          department: data.department ?? "",
          departmentKana: data.departmentKana ?? "",
          branch: data.branch ?? "",
          branchKana: data.branchKana ?? "",
          branchDepartment: data.branchDepartment ?? "",
          contactName: data.contactName ?? "",
          contactNameKana: data.contactNameKana ?? "",
          postalCode: data.postalCode ?? "",
          address: data.address ?? "",
          postalCode2: data.postalCode2 ?? "",
          address2: data.address2 ?? "",
          tel: data.tel ?? "",
          fax: data.fax ?? "",
          email: data.email ?? "",
          establishedMonth: data.establishedMonth ?? "",
          establishedYear: data.establishedYear ?? "",
          businessType: data.businessType ?? "",
          employeeCount: data.employeeCount ?? "",
          region: data.region ?? "",
          industry: data.industry ?? "",
          mainProducts: data.mainProducts ?? "",
          privateName: data.privateName ?? "",
          website: data.website ?? "",
          manager: data.manager ?? "",
          status: data.status ?? "",
          pcType: data.pcType ?? "",
          lanEnv: data.lanEnv ?? "",
          envContactName: data.envContactName ?? "",
          note: data.note ?? "",
          displayFlag: data.displayFlag ?? true,
          mainCustomer: data.mainCustomer ?? false,
        })
      );
  }, [id, isEdit]);

  const set = (key: keyof FormData, value: string | boolean) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    try {
      const url = isEdit ? `/api/customers/${id}` : "/api/customers";
      const method = isEdit ? "PUT" : "POST";
      const res = await window.fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form),
      });
      const saved = await res.json();
      navigate(`/customers/${saved.id}`);
    } finally {
      setSaving(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div style={styles.toolbar}>
        <Link to={isEdit ? `/customers/${id}` : "/customers"}>← 戻る</Link>
        <h2 style={{ fontSize: 16, fontWeight: "bold", marginLeft: 8 }}>
          {isEdit ? "顧客情報を編集" : "新規顧客登録"}
        </h2>
        <div style={{ marginLeft: "auto", display: "flex", gap: 8 }}>
          <button
            type="button"
            style={styles.btnSecondary}
            onClick={() => navigate(isEdit ? `/customers/${id}` : "/customers")}
          >
            キャンセル
          </button>
          <button type="submit" style={styles.btnPrimary} disabled={saving}>
            {saving ? "保存中..." : "保存"}
          </button>
        </div>
      </div>

      <div style={styles.section}>
        <div style={styles.sectionTitle}>基本情報</div>
        <div style={styles.grid}>
          <Field label="会社名 *">
            <input
              style={styles.input}
              value={form.companyName}
              onChange={(e) => set("companyName", e.target.value)}
              required
            />
          </Field>
          <Field label="会社名（ふりがな）">
            <input
              style={styles.input}
              value={form.companyNameKana}
              onChange={(e) => set("companyNameKana", e.target.value)}
            />
          </Field>
          <Field label="分類">
            <input
              style={styles.input}
              value={form.classification}
              onChange={(e) => set("classification", e.target.value)}
            />
          </Field>
          <Field label="部署">
            <input
              style={styles.input}
              value={form.department}
              onChange={(e) => set("department", e.target.value)}
            />
          </Field>
          <Field label="部署（ふりがな）">
            <input
              style={styles.input}
              value={form.departmentKana}
              onChange={(e) => set("departmentKana", e.target.value)}
            />
          </Field>
          <Field label="支店名">
            <input
              style={styles.input}
              value={form.branch}
              onChange={(e) => set("branch", e.target.value)}
            />
          </Field>
          <Field label="担当者名">
            <input
              style={styles.input}
              value={form.contactName}
              onChange={(e) => set("contactName", e.target.value)}
            />
          </Field>
          <Field label="担当者（ふりがな）">
            <input
              style={styles.input}
              value={form.contactNameKana}
              onChange={(e) => set("contactNameKana", e.target.value)}
            />
          </Field>
        </div>
      </div>

      <div style={styles.section}>
        <div style={styles.sectionTitle}>連絡先</div>
        <div style={styles.grid}>
          <Field label="TEL">
            <input style={styles.input} value={form.tel} onChange={(e) => set("tel", e.target.value)} />
          </Field>
          <Field label="FAX">
            <input style={styles.input} value={form.fax} onChange={(e) => set("fax", e.target.value)} />
          </Field>
          <Field label="メール">
            <input style={styles.input} type="email" value={form.email} onChange={(e) => set("email", e.target.value)} />
          </Field>
          <Field label="Webサイト">
            <input style={styles.input} value={form.website} onChange={(e) => set("website", e.target.value)} />
          </Field>
          <Field label="郵便番号">
            <input style={styles.input} value={form.postalCode} onChange={(e) => set("postalCode", e.target.value)} />
          </Field>
          <Field label="住所">
            <input style={styles.input} value={form.address} onChange={(e) => set("address", e.target.value)} />
          </Field>
        </div>
      </div>

      <div style={styles.section}>
        <div style={styles.sectionTitle}>属性</div>
        <div style={styles.grid}>
          <Field label="状態">
            <input style={styles.input} value={form.status} onChange={(e) => set("status", e.target.value)} />
          </Field>
          <Field label="地域">
            <input style={styles.input} value={form.region} onChange={(e) => set("region", e.target.value)} />
          </Field>
          <Field label="業種">
            <input style={styles.input} value={form.industry} onChange={(e) => set("industry", e.target.value)} />
          </Field>
          <Field label="業態">
            <input style={styles.input} value={form.businessType} onChange={(e) => set("businessType", e.target.value)} />
          </Field>
          <Field label="従業員数">
            <input style={styles.input} value={form.employeeCount} onChange={(e) => set("employeeCount", e.target.value)} />
          </Field>
          <Field label="担当者">
            <input style={styles.input} value={form.manager} onChange={(e) => set("manager", e.target.value)} />
          </Field>
        </div>
      </div>

      <div style={styles.section}>
        <div style={styles.sectionTitle}>備考</div>
        <textarea
          style={{ ...styles.input, height: 120, resize: "vertical" }}
          value={form.note}
          onChange={(e) => set("note", e.target.value)}
        />
      </div>

      <div style={{ display: "flex", justifyContent: "flex-end", gap: 8 }}>
        <button
          type="button"
          style={styles.btnSecondary}
          onClick={() => navigate(isEdit ? `/customers/${id}` : "/customers")}
        >
          キャンセル
        </button>
        <button type="submit" style={styles.btnPrimary} disabled={saving}>
          {saving ? "保存中..." : "保存"}
        </button>
      </div>
    </form>
  );
}
