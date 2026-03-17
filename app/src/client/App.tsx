import { Routes, Route, Navigate } from "react-router-dom";
import Layout from "./components/Layout.js";
import CustomerList from "./pages/CustomerList.js";
import CustomerDetail from "./pages/CustomerDetail.js";
import CustomerForm from "./pages/CustomerForm.js";

export default function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<Navigate to="/customers" replace />} />
        <Route path="/customers" element={<CustomerList />} />
        <Route path="/customers/new" element={<CustomerForm />} />
        <Route path="/customers/:id" element={<CustomerDetail />} />
        <Route path="/customers/:id/edit" element={<CustomerForm />} />
      </Routes>
    </Layout>
  );
}
