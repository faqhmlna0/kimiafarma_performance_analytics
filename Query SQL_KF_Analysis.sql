-- Membuat Tabel KF_Analysis
CREATE TABLE kimia_farma.kf_analysis AS

-- CTE untuk Membuat Tabel PersentaseGrossLaba
WITH PersentaseGrossLaba AS (
  SELECT 
    product_id, 
    price,
    CASE 
      WHEN price > 500000 THEN 0.30
      WHEN price > 300000 THEN 0.25
      WHEN price > 100000 THEN 0.20
      WHEN price > 50000 THEN 0.15
    ELSE 0.10
  END AS persentase_gross_laba
  FROM rakamin-kf-analytics-faqih.kimia_farma.kf_product
)
-- Query Isi dari KF_Analysis
SELECT
  ft.transaction_id, 
  ft.date,
  ft.branch_id, 
  kc.branch_name, 
  kc.kota AS city, 
  kc.provinsi AS province, 
  kc.rating AS rating_cabang,
  ft.customer_name, 
  ft.product_id,
  p.product_name, 
  p.price AS actual_price, 
  ft.discount_percentage,
  pgl.persentase_gross_laba,
  p.price - (p.price * ft.discount_percentage) AS nett_sales,
  (p.price - (p.price * ft.discount_percentage)) * pgl.persentase_gross_laba AS nett_profit,
  ft.rating AS transaction_rating
FROM PersentaseGrossLaba AS pgl
JOIN rakamin-kf-analytics-faqih.kimia_farma.kf_final_transaction AS ft ON pgl.product_id = ft.product_id
JOIN rakamin-kf-analytics-faqih.kimia_farma.kf_product AS p ON ft.product_id = p.product_id 
JOIN rakamin-kf-analytics-faqih.kimia_farma.kf_kantor_cabang AS kc ON ft.branch_id = kc.branch_id