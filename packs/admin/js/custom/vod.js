function handleLinkChoose() {
   // Sử dụng JavaScript thuần túy
   let checkboxes = document.querySelectorAll('input[type="checkbox"]');
   let checkedCheckboxes = [];

   // Lặp qua tất cả các checkbox và kiểm tra xem chúng có được chọn không
   checkboxes.forEach((button) => {
      if (button.checked) {
         const row = button.getAttribute("data-row");
         const cname = button.getAttribute("data-cname");

         checkedCheckboxes.push({ ...JSON.parse(row), cname });
      }
   });

   // Gọi hàm mở modal và chuyển giá trị của các checkbox đã chọn
   openModal(checkedCheckboxes);
}

// Hàm để mở modal LayUI và chứa một bảng bên trong
function openModal(data) {
   layui.use("layer", function () {
      let layer = layui.layer;

      let th = '<th width="15%">Video name</th>';
      th += "<th>Capacity</th>";
      th += "<th>Category</th>";
      th += "<th>Views</th>";
      th += "<th>Status</th>";
      th += "<th>Release time</th>";
      th += "<th>Direct link</th>";
      th += "<th>Iframe link</th>";
	  th += "<th>Backup link</th>";
      // Tạo mã HTML cho bảng
      let tableHTML = `<table id="export-excel" class='layui-table'><thead><tr>${th}</tr></thead><tbody>`;

      data.forEach(function (item) {
         tableHTML +=
            "<tr>" +
            `<td>${item.name}</td>` +
            `<td>${formatBytes(item.size)}</td>` +
            `<td>${item.cname}</td>` +
            `<td>${item.hits}</td>` +
            `<td>${+item.zt === 2 ? "Transcoded" : "Transcoding fail"}</td>` +
            `<td>${formatDate(item.addtime).toLocaleString().slice(0, 19).replace("T", " ")}</td>` +
            `<td>https://14412882.com/play/index/${item.vid}</td>` +
            `<td>${escapeHTML(
               `<iframe width="100%" height="100%" src="https://14412882.com/play/index/${item.vid}" frameborder="0" allowfullscreen></iframe>`
            )}</td>` +
			`<td>https://14412882.net/play/index/${item.vid}</td>` +
            "</tr>";
      });
      tableHTML += "</tbody></table>";

      // Mở modal
      layer.open({
         type: 1,
         title: "EXPORT LINK SELECED",
         content: tableHTML,
         area: ["90%", "600px"],
         success: function (layero, index) {
            // Đặt màu nền cho modal
            layero.find(".layui-layer-content").css({
               "background-color": "white",
            });
         },
         btn: [`<span><i class='fa fa-file-excel-o' aria-hidden='true'></i> Export xlsx<span>`], // Button footer
         yes: function (index, layero) {
            // Code khi nhấn nút OK
            const table = document.getElementById("export-excel");
            const wb = XLSX.utils.table_to_book(table, { sheet: "Sheet1" });

            // Xuất tệp Excel và tải xuống
            return XLSX.writeFile(wb, "exported_link.xlsx");
         },
      });
   });
}

function formatBytes(bytes, decimals = 2) {
   if (bytes === 0) return "0 Bytes";

   const k = 1024;
   const dm = decimals < 0 ? 0 : decimals;
   const sizes = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

   const i = Math.floor(Math.log(bytes) / Math.log(k));

   return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + " " + sizes[i];
}

function formatDate(timestamp) {
   const date = new Date(timestamp * 1000);
   const day = date.getDate();
   const month = date.getMonth() + 1;
   const year = date.getFullYear();
   const hours = date.getHours() + 1;
   const minutes = "0" + date.getMinutes();
   const seconds = "0" + date.getSeconds();

   return (
      hours +
      ":" +
      minutes.substr(-2) +
      ":" +
      seconds.substr(-2) +
      " " +
      day +
      "/" +
      month +
      "/" +
      year
   );
}

function escapeHTML(text) {
   return text.replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

const handleIconSelected = () => {
   const url = window.location.href;
   const sortAsc = url.indexOf("sort_by=asc") !== -1;
   const sortDesc = url.indexOf("sort_by=desc") !== -1;
   const titleIndex = url.indexOf("title=");
   const titleValue = url.substring(titleIndex + 6).split("&")[0];

   const $iconAsc = $("#asc-icon-" + titleValue);
   const $iconDesc = $("#desc-icon-" + titleValue);

   if (sortAsc && !sortDesc) {
      $iconAsc.addClass("active");
      $iconDesc.removeClass("active");
   }
   if (!sortAsc && sortDesc) {
      $iconAsc.removeClass("active");
      $iconDesc.addClass("active");
   }
};

handleIconSelected();
