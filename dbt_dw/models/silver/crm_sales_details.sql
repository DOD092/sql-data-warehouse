SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    CASE 
    -- Nếu order date hợp lệ thì convert bình thường
    WHEN sls_order_dt != 0 
         AND LEN(CAST(sls_order_dt AS VARCHAR)) = 8
    THEN TRY_CONVERT(DATE, CAST(sls_order_dt AS VARCHAR), 112)

    -- Nếu order date bị lỗi nhưng ship date hợp lệ
    -- thì suy ra order date = ship date - 7 ngày
    WHEN sls_ship_dt != 0 
         AND LEN(CAST(sls_ship_dt AS VARCHAR)) = 8
    THEN DATEADD(DAY, -7, TRY_CONVERT(DATE, CAST(sls_ship_dt AS VARCHAR), 112))

    -- Nếu cả order date và ship date đều không hợp lệ thì để NULL
    ELSE NULL
    END AS sls_order_dt,

    CASE 
        WHEN sls_ship_dt = 0 OR LEN(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,

    CASE 
        WHEN sls_due_dt = 0 OR LEN(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,

    CASE 
        WHEN sls_sales IS NULL 
          OR sls_sales <= 0 
          OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    sls_quantity,

    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0 
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE ABS(sls_price)
    END AS sls_price,

    GETDATE() AS dwh_create_date

FROM {{ source('bronze', 'crm_sales_details') }}