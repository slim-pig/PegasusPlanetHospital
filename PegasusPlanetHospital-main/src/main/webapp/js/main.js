/**
 * 飞马星球医院 - 主JavaScript文件
 */

document.addEventListener('DOMContentLoaded', function() {
    // 初始化工具提示等
    
    // 自动关闭警告框
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(() => {
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    }
    
    // 表单验证
    const forms = document.querySelectorAll('form.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
    
    // 确认删除
    const deleteLinks = document.querySelectorAll('.delete-confirm');
    deleteLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            if (!confirm('确定要删除这条记录吗？此操作不可恢复。')) {
                e.preventDefault();
            }
        });
    });
});

/**
 * 检查手机号是否已注册
 */
function checkPhone(phoneInput) {
    const phone = phoneInput.value;
    const feedback = document.getElementById('phone-feedback');
    
    if (phone.length === 11) {
        fetch(`api?resource=checkPhone&phone=${phone}`)
            .then(response => response.json())
            .then(data => {
                if (data.exists) {
                    phoneInput.setCustomValidity('该手机号已注册');
                    feedback.textContent = '该手机号已注册';
                    feedback.style.display = 'block';
                    feedback.style.color = '#dc3545';
                } else {
                    phoneInput.setCustomValidity('');
                    feedback.style.display = 'none';
                }
            })
            .catch(error => console.error('Error:', error));
    }
}

/**
 * 级联加载医生列表
 */
function loadDoctors(deptSelect, doctorSelectId) {
    const deptId = deptSelect.value;
    const doctorSelect = document.getElementById(doctorSelectId);
    
    // 清空现有选项
    doctorSelect.innerHTML = '<option value="">-- 请选择医生 --</option>';
    
    if (deptId) {
        fetch(`api?resource=doctors&deptId=${deptId}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    data.data.forEach(doctor => {
                        const option = document.createElement('option');
                        option.value = doctor.doctorId;
                        option.textContent = `${doctor.name} (${doctor.title})`;
                        doctorSelect.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Error:', error));
    }
}

/**
 * 异步取消预约
 */
function cancelAppointment(appointmentId, btn) {
    const reason = prompt("请输入取消原因：");
    if (reason === null) return; // 用户点击取消
    
    fetch('appointment', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
        },
        body: `action=cancel&id=${appointmentId}&reason=${encodeURIComponent(reason)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('预约已取消');
            location.reload();
        } else {
            alert('取消失败: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('操作失败，请稍后重试');
    });
}

/**
 * 打印报表
 */
function printReport() {
    window.print();
}
