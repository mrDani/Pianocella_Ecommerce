document.addEventListener("DOMContentLoaded", function () {
    console.log("✅ JavaScript Loaded");
  
    const provinceSelect = document.getElementById('province-select');
    const totalPriceElement = document.getElementById('total-price');
    const pstElement = document.getElementById('pst');
    const gstElement = document.getElementById('gst');
    const hstElement = document.getElementById('hst');
    const totalWithTaxesElement = document.getElementById('total-with-taxes');
  
    if (!provinceSelect || !totalPriceElement || !pstElement || !gstElement || !hstElement || !totalWithTaxesElement) {
      console.error("❌ Missing elements in DOM");
      return;
    }
  
    const baseTotal = parseFloat(totalPriceElement.innerText) || 0.0;
  
    function calculateTaxes() {
      const selectedProvince = provinceSelect.value;
      const taxRates = window.PROVINCE_TAXES[selectedProvince];
  
      if (!taxRates) {
        console.warn(`⚠️ No tax data for province: ${selectedProvince}`);
        pstElement.innerText = "0.00";
        gstElement.innerText = "0.00";
        hstElement.innerText = "0.00";
        totalWithTaxesElement.innerText = baseTotal.toFixed(2);
        return;
      }
  
      const pst = baseTotal * taxRates.pst;
      const gst = baseTotal * taxRates.gst;
      const hst = baseTotal * taxRates.hst;
      const totalWithTaxes = baseTotal + pst + gst + hst;
  
      pstElement.innerText = pst.toFixed(2);
      gstElement.innerText = gst.toFixed(2);
      hstElement.innerText = hst.toFixed(2);
      totalWithTaxesElement.innerText = totalWithTaxes.toFixed(2);
  
      console.log("✅ Tax calculation updated", { selectedProvince, ...taxRates, totalWithTaxes });
    }
  
    provinceSelect.addEventListener('change', calculateTaxes);
    if (provinceSelect.value) calculateTaxes(); // Trigger on load
  });
  