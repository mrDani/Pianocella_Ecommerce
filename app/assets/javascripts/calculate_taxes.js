document.addEventListener("DOMContentLoaded", function () {
    console.log("✅ JavaScript Loaded Successfully");

    // Wrap everything in a timeout to ensure the DOM is fully rendered
    setTimeout(() => {
        const provinceSelect = document.getElementById('province-select');
        const totalPriceElement = document.getElementById('total-price');
        const pstElement = document.getElementById('pst');
        const gstElement = document.getElementById('gst');
        const totalWithTaxesElement = document.getElementById('total-with-taxes');

        if (!provinceSelect || !totalPriceElement || !pstElement || !gstElement || !totalWithTaxesElement) {
            console.error("❌ Required elements are missing from the DOM.");
            console.error({
                provinceSelect, totalPriceElement, pstElement, gstElement, totalWithTaxesElement
            });
            return;
        }

        console.log("✅ Elements Found", { provinceSelect, totalPriceElement, pstElement, gstElement, totalWithTaxesElement });

        provinceSelect.addEventListener('change', function () {
            console.log("🌟 Province Changed:", provinceSelect.value);

            const province = provinceSelect.value;
            const baseTotal = parseFloat(totalPriceElement.innerText) || 0.0;

            let pstRate = 0;
            let gstRate = 0.05;

            switch (province) {
                case 'Alberta':
                    pstRate = 0.00;
                    break;
                case 'British Columbia':
                    pstRate = 0.07;
                    break;
                case 'Manitoba':
                    pstRate = 0.07;
                    break;
                case 'New Brunswick':
                    pstRate = 0.10; // HST (harmonized)
                    gstRate = 0.00;
                    break;
                case 'Newfoundland and Labrador':
                    pstRate = 0.10; // HST
                    gstRate = 0.00;
                    break;
                case 'Nova Scotia':
                    pstRate = 0.10; // HST
                    gstRate = 0.00;
                    break;
                case 'Ontario':
                    pstRate = 0.08;
                    break;
                case 'Prince Edward Island':
                    pstRate = 0.10; // HST
                    gstRate = 0.00;
                    break;
                case 'Quebec':
                    pstRate = 0.09975;
                    break;
                case 'Saskatchewan':
                    pstRate = 0.06;
                    break;
                case 'Northwest Territories':
                case 'Nunavut':
                case 'Yukon':
                    pstRate = 0.00;
                    break;
                default:
                    pstRate = 0;
                    break;
            }

            const pst = baseTotal * pstRate;
            const gst = baseTotal * gstRate;
            const totalWithTaxes = baseTotal + pst + gst;

            pstElement.innerText = pst.toFixed(2);
            gstElement.innerText = gst.toFixed(2);
            totalWithTaxesElement.innerText = totalWithTaxes.toFixed(2);

            console.log("✅ Calculation Complete", { pst, gst, totalWithTaxes });
        });
    }, 100);  // Delay of 100 milliseconds to allow DOM to render completely
});
