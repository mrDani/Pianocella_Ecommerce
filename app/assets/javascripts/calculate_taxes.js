document.addEventListener("DOMContentLoaded", function () {
    console.log("✅ JavaScript Loaded Successfully");

    function calculateTaxes() {
        const provinceSelect = document.getElementById('province-select');
        const totalPriceElement = document.getElementById('total-price');
        const pstElement = document.getElementById('pst');
        const gstElement = document.getElementById('gst');
        const totalWithTaxesElement = document.getElementById('total-with-taxes');

        if (!provinceSelect || !totalPriceElement || !pstElement || !gstElement || !totalWithTaxesElement) {
            console.error("❌ Required elements are missing from the DOM.");
            return;
        }

        const province = provinceSelect.value;
        const baseTotal = parseFloat(totalPriceElement.innerText) || 0.0;

        let pstRate = 0;
        let gstRate = 0.05;

        switch (province) {
            case 'Alberta':
                pstRate = 0.00; break;
            case 'British Columbia':
                pstRate = 0.07; break;
            case 'Manitoba':
                pstRate = 0.07; break;
            case 'New Brunswick':
            case 'Newfoundland and Labrador':
            case 'Nova Scotia':
            case 'Prince Edward Island':
                pstRate = 0.10; gstRate = 0.00; break;
            case 'Ontario':
                pstRate = 0.08; break;
            case 'Quebec':
                pstRate = 0.09975; break;
            case 'Saskatchewan':
                pstRate = 0.06; break;
            case 'Northwest Territories':
            case 'Nunavut':
            case 'Yukon':
                pstRate = 0.00; break;
            default:
                pstRate = 0;
        }

        const pst = baseTotal * pstRate;
        const gst = baseTotal * gstRate;
        const totalWithTaxes = baseTotal + pst + gst;

        pstElement.innerText = pst.toFixed(2);
        gstElement.innerText = gst.toFixed(2);
        totalWithTaxesElement.innerText = totalWithTaxes.toFixed(2);

        console.log("✅ Tax calculation updated", { province, pst, gst, totalWithTaxes });
    }

    requestAnimationFrame(() => {
        const provinceSelect = document.getElementById('province-select');
        if (provinceSelect) {
            provinceSelect.addEventListener('change', calculateTaxes);

            // Trigger immediately if there's a value selected already
            if (provinceSelect.value && provinceSelect.value !== "") {
                console.log("🌟 Triggering tax calculation on page load for:", provinceSelect.value);
                calculateTaxes(); // Call directly
            }
        }
    });
});
