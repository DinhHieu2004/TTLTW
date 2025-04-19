<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="row">
  <div class="col-6">
    <div class="card mb-4">
      <div class="card-header bg-secondary text-white">
        <h4>Role</h4>
      </div>
      <div class="card-body">
        <table id="roles" class="table table-bordered display">
          <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addRoleModal">
            Thêm Role
          </button>
          <thead>
          <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Hành Động</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="role" items="${roles}">
            <tr>
              <td>${role.id}</td>
              <td>${role.name}</td>
              <td>
                <button class="btn btn-info btn-sm" data-bs-toggle="modal"
                        data-bs-target="#editRoleModal" data-role-id="${role.id}">Sửa
                </button>
                <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                        data-bs-target="#deleteRolesModal" data-role-id="${role.id}">Xóa
                </button>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="col-6">
    <div class="card mb-4">
      <div class="card-header bg-secondary text-white">
        <h4>Danh sách Permission</h4>
      </div>
      <div class="card-body">
        <table id="permission" class="table table-bordered display">
          <thead>
          <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Mô tả</th>
       <!--     <th>Hành động</th> -->
          </tr>
          </thead>
          <tbody>
          <c:forEach var="p" items="${permissions}">
            <tr>
              <td>${p.id}</td>
              <td>${p.name}</td>
              <td>${p.description}</td>
         <!--     <td>
                <button class="btn btn-info btn-sm" data-bs-toggle="modal"
                        data-bs-target="#viewEditPermissionsModal" data-permission-id="${p.id}">Xem Chi Tiết
                </button>
                <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                        data-bs-target="#deletePermissionsModal" data-permission-id="${p.id}">Xóa
                </button>
              </td> -->
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Modal Edit Role -->
<div class="modal fade" id="editRoleModal" tabindex="-1" aria-labelledby="editRoleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editRoleModalLabel">Chỉnh sửa Role</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="editRoleForm">
          <input type="hidden" id="editRoleId" name="roleId" value="">

          <div class="mb-3">
            <label for="idRole" class="form-label">Mã Role: #</label>
            <strong id="idRole"></strong>
          </div>
          <div class="mb-3">
            <label for="editRoleName" class="form-label">Tên Role</label>
            <input type="text" class="form-control" id="editRoleName" name="roleName" required>
          </div>


          <div class="mb-3">
            <label class="form-label">Quản lý quyền</label>
            <div class="row">
              <div class="col-6">
                <h6>Quyền hiện tại</h6>
                <div id="currentPermissions" class="permission-list scrollable"></div>
              </div>
              <div class="col-6">
                <h6>Thêm quyền mới</h6>
                <div id="availablePermissions" class="permission-list scrollable">
                  <c:forEach var="permission" items="${permissions}">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" name="newPermissionIds"
                             id="new_permission_${permission.id}" value="${permission.id}">
                      <label class="form-check-label" for="new_permission_${permission.id}">
                          ${permission.name} (ID: ${permission.id})
                      </label>
                    </div>
                  </c:forEach>
                </div>
              </div>
            </div>
          </div>

          <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- Modal Add Role -->
<div class="modal fade" id="addRoleModal" tabindex="-1" aria-labelledby="addRoleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addRoleModalLabel">Thêm Role Mới</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="addRoleForm">
          <div class="mb-3">
            <label for="addRoleName" class="form-label">Tên Role</label>
            <input type="text" class="form-control" id="addRoleName" name="roleName" required>
          </div>

          <div class="mb-3">
            <label class="form-label">Chọn Quyền</label>
            <div id="permissions" class="permission-list scrollable">
              <c:forEach var="permission" items="${permissions}">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="permissionIds"
                         id="new_permission_${permission.id}" value="${permission.id}">
                  <label class="form-check-label" for="new_permission_${permission.id}">
                      ${permission.name} (ID: ${permission.id})
                  </label>
                </div>
              </c:forEach>
            </div>
          </div>

          <button type="submit" class="btn btn-primary">Thêm Role</button>
        </form>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="deleteRolesModal" tabindex="-1" aria-labelledby="deleteRolesModalLabel"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteRolesModalLabel">Xác nhận xóa</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form >
        <div class="modal-body">
          <p>Bạn có chắc chắn muốn xóa role này?</p>
          <input type="hidden" id="roleIdToDelete" name="roleId">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-danger">Xóa</button>
        </div>
      </form>
    </div>
  </div>
</div>

<style>
  .permission-list {
    max-height: 200px;
    overflow-y: auto;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  .scrollable::-webkit-scrollbar {
    width: 8px;
  }
  .scrollable::-webkit-scrollbar-thumb {
    background-color: #888;
    border-radius: 4px;
  }
  .scrollable::-webkit-scrollbar-thumb:hover {
    background-color: #555;
  }
</style>

<!-- Script để xử lý modal -->
<script>
  $(document).ready(function () {
    $('#editRoleModal').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget);
      var roleId = button.data('role-id');

      $.ajax({
        url: 'roles/detail',
        type: 'GET',
        data: { roleId: roleId },
        dataType: 'json',
        success: function (role) {

          $('#editRoleId').val(role.id);
          $('#idRole').text(role.id);
          $('#editRoleName').val(role.name);

          var currentPermissionsDiv = $('#currentPermissions');
          currentPermissionsDiv.empty();

          if (!role.permissions || !Array.isArray(role.permissions) || role.permissions.length === 0) {
            currentPermissionsDiv.html('<p class="text-muted">Không có quyền nào.</p>');
          } else {
            var permissionsHTML = '';

            role.permissions.forEach(function (permission, index) {
              if (permission && typeof permission.id !== 'undefined' && typeof permission.name !== 'undefined') {
                var permId = permission.id;
                var permName = permission.name;

                permissionsHTML +=
                        '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="currentPermissionIds" ' +
                        'id="current_permission_' + permId + '" value="' + permId + '" checked>' +
                        '<label class="form-check-label" for="current_permission_' + permId + '">' +
                        permName + ' (ID: ' + permId + ')' +
                        '</label>' +
                        '</div>';

              } else {
              }
            });

            if (permissionsHTML === '') {
              currentPermissionsDiv.html('<p class="text-muted">Không có quyền hợp lệ.</p>');
              console.log("Step 9 - No valid permissions to display");
            } else {
              currentPermissionsDiv.html(permissionsHTML);
              console.log("Step 9 - Set permissionsHTML to currentPermissions div");
              console.log("Step 9.1 - Current div content:", currentPermissionsDiv.html());
            }
          }

          $('#availablePermissions input[name="newPermissionIds"]').each(function () {
            var permissionId = $(this).val();
            var isAlreadyAssigned = role.permissions.some(function (p) { return p && p.id == permissionId; });
            $(this).prop('checked', false);
            $(this).parent().toggle(!isAlreadyAssigned);
          });
        },
        error: function (xhr, status, error) {
          console.error('AJAX Error:', status, error);
          alert('Không thể tải thông tin role!');
        }
      });
    });
    $(document).ready(function () {
      $('#permission').DataTable();
      $('#roles').DataTable();


      $('#editRoleForm').on('submit', function (e) {
        e.preventDefault();

        var roleId = $('#editRoleId').val();
        var roleName = $('#editRoleName').val();

        var selectedPermissionIds = $('input[name="currentPermissionIds"]:checked')
                .map(function () { return this.value; })
                .get();

        var newPermissionIds = $('input[name="newPermissionIds"]:checked')
                .map(function () { return this.value; })
                .get();

        var allPermissions = [...selectedPermissionIds, ...newPermissionIds];

        console.log("roleId:", roleId);
        console.log("roleName:", roleName);
        console.log("selectedPermissionIds:", selectedPermissionIds);
        console.log("newPermissionIds:", newPermissionIds);
        console.log("allPermissions:", allPermissions);

        var formData = new URLSearchParams();
        formData.append("roleId", roleId);
        formData.append("roleName", roleName);
        allPermissions.forEach(function(permissionId) {
          formData.append("permissionIds", permissionId);
        });

        console.log("Submitting form data:", formData.toString());

        $.ajax({
          url: 'roles/update',
          type: 'POST',
          data: formData.toString(),
          contentType: 'application/x-www-form-urlencoded',
          processData: false,
          success: function (response) {
            alert('Cập nhật quyền thành công!');
            $('#editRoleModal').modal('hide');
            updateRoleList(roleId, roleName, allPermissions);
          },
          error: function (xhr, status, error) {
            if (xhr.status === 403) {
              let response = JSON.parse(xhr.responseText);
              alert(response.message || "Bạn không có quyền thực hiện thao tác này!");
            } else if (xhr.status === 400) {
              let response = JSON.parse(xhr.responseText);
              alert("Lỗi dữ liệu: " + response.message);
            } else {
              console.error('Lỗi cập nhật quyền:', error);
              alert('Cập nhật quyền thất bại! Vui lòng thử lại.');
            }
          }
        });

      });
    });

    function updateRoleList(roleId, roleName, permissionIds) {
      var $row = $('#roles tbody tr').filter(function() {
        return $(this).find('td:first').text() === roleId;
      });

      if ($row.length) {
        $row.find('td:nth-child(2)').text(roleName);
        console.log("Updated role " + roleId + " in table");
      } else {
        console.log("Role " + roleId + " not found in table");
      }
    }
  });




  $(document).ready(function () {
    $('#addRoleForm').on('submit', function (e) {
      e.preventDefault();

      var roleName = $('#addRoleName').val().trim();
      var permissionIds = $('input[name="permissionIds"]:checked')
              .map(function () { return this.value; })
              .get();

      if (!roleName) {
        alert('Vui lòng nhập tên role!');
        return;
      }

      var formData = new URLSearchParams();
      formData.append("roleName", roleName);
      permissionIds.forEach(function(permissionId) {
        formData.append("permissionIds", permissionId);
      });

      console.log("Submitting form data:", formData.toString());

      $.ajax({
        url: 'roles/add',
        type: 'POST',
        data: formData.toString(),
        contentType: 'application/x-www-form-urlencoded',
        processData: false,
        success: function (response) {
          try {
            if (typeof response === "string") {
              response = JSON.parse(response);
            }

            console.log("API Response:", response);

            if (response.roleId) {
              alert('Thêm role thành công!');
              $('#addRoleModal').modal('hide');
              addRoleToTable(response);
            } else {
              console.error("Lỗi: roleId không tồn tại trong phản hồi!");
            }
          } catch (error) {
            console.error("Lỗi parse JSON:", error);
            alert('Lỗi không xác định!');
          }
        },
        error: function (xhr, status, error) {
          console.error('Lỗi thêm role:', error);
          alert('Thêm role thất bại! Vui lòng thử lại.');
        },
        complete: function () {
          // Reset form
          $('#addRoleForm')[0].reset();
        }
      });
    });

    function addRoleToTable(response) {
      var roleId = response.roleId;
      var roleName = response.roleName || $('#addRoleName').val();

      if (!roleId) {
        console.error("Lỗi: Không có roleId từ server!");
        return;
      }

      var table = $('#roles').DataTable();
      var newRow = [
        roleId,
        roleName,
        '<button class="btn btn-info btn-sm" data-bs-toggle="modal" ' +
        'data-bs-target="#editRoleModal" data-role-id="' + roleId + '">Sửa</button>' +
        '<button class="btn btn-danger btn-sm" data-bs-toggle="modal" ' +
        'data-bs-target="#deleteRolesModal" data-role-id="' + roleId + '">Xóa</button>'
      ];

      table.row.add(newRow).draw();
    }


    $('#addRoleModal').on('hidden.bs.modal', function () {
      $('#addRoleForm')[0].reset();
      $('#addRoleForm .is-invalid').removeClass('is-invalid');
      $('#addRoleForm .invalid-feedback').remove();
    });


    $('#addRoleName').on('input', function () {
      var $this = $(this);
      if ($this.val().trim() === '') {
        $this.addClass('is-invalid');
        if ($this.next('.invalid-feedback').length === 0) {
          $this.after('<div class="invalid-feedback">Tên role không được để trống</div>');
        }
      } else {
        $this.removeClass('is-invalid');
        $this.next('.invalid-feedback').remove();
      }
    });


    document.addEventListener('click', function (event) {
      if (event.target.matches('[data-bs-target="#deleteRolesModal"]')) {
        let roleId = event.target.getAttribute('data-role-id');
        document.getElementById('roleIdToDelete').value = roleId;
      }
    });

    $('#deleteRolesModal form').on('submit', function (e) {
      e.preventDefault();
      var table = $('#roles').DataTable();

      let roleId = $('#roleIdToDelete').val();
      if (!roleId) {
        Swal.fire('Lỗi', 'Không tìm thấy ID vai trò!', 'error');
        return;
      }

      $.ajax({
        type: "POST",
        url: "roles/delete",
        data: { id: roleId },
        success: function (response) {
          if (response.status === "success") {
            var $row = $('[data-role-id="' + roleId + '"]').closest('tr');
            table.row($row).remove().draw(false);

            $('#deleteRolesModal').modal('hide');

            Swal.fire({
              icon: 'success',
              title: 'Đã xóa thành công!',
              showConfirmButton: false,
              timer: 2000,
              position: 'center',
            });
          } else {
            Swal.fire('Thất bại', response.message || 'Không thể xóa vai trò.', 'error');
          }
        },
        error: function (xhr) {
          Swal.fire('Lỗi', 'Đã xảy ra lỗi khi gửi yêu cầu xóa.', 'error');
        }
      });
    });
  });
</script>