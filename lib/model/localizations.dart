Map<String, dynamic> appLocalizations = {
  "server-error": {
    "en": "Can't connect to server, try again later.",
    "vi": "Lỗi, không thể kết nối đến máy chủ, vui lòng thử lại sau.",
  },
  "password-textfield-title": {
    "en": "Password",
    "vi": "Mật khẩu",
  },
  "password2-textfield-title": {
    "en": "Re enter password",
    "vi": "Xác nhận mật khẩu",
  },
  "password2-error-textfield-title": {
    "en": "Password not match",
    "vi": "Mật khẩu xác nhận không đúng",
  },
  "name-textfield-title": {
    "en": "Fullname",
    "vi": "Họ và tên",
  },
  "login-button-title": {
    "en": "Login",
    "vi": "Đăng nhập",
  },
  "register-button-title": {
    "en": "Register",
    "vi": "Đăng ký",
  },
  "back-button-title": {
    "en": "< Back",
    "vi": "< Trở về",
  },
  "reset-password-button-title": {
    "en": "Reset password",
    "vi": "Đặt lại mật khẩu",
  },
  "forgot-password-button-title": {
    "en": "Forgot password?",
    "vi": "Quên mật khẩu?",
  },
  "forgot-password-description": {
    "en": "Enter your email address to reset your password",
    "vi": "Nhập địa chỉ email của bạn để đặt lại mật khẩu",
  },
  "or-title": {
    "en": "or",
    "vi": "hoặc",
  },
  "loading-text": {
    "en": "Loading...",
    "vi": "Đang load...",
  },
  "no-donation-text": {
    "en": "You haven't made any donation yet.",
    "vi": "Bạn chưa có quyên góp nào.",
  },
  "no-received-donation-text": {
    "en": "You haven't received any donation yet.",
    "vi": "Bạn chưa nhận quyên góp nào.",
  },
  "no-available-donation-text": {
    "en": "No available donation found",
    "vi": "Không tìm thấy quyên góp nào",
  },
  "receive-donation-success-description": {
    "en": "You have received this donation",
    "vi": "Bạn đã nhận quyên góp này",
  },
  "receive-donation-success-text": {
    "en": "Receive success",
    "vi": "Nhận thành công",
  },
  "write-a-review-text": {
    "en": "Write a review",
    "vi": "Viết đánh giá",
  },
  "rate-this-donation-title": {
    "en": "Rate this donation",
    "vi": "Đánh giá quyên góp này",
  },
  "new-donation-title": {
    "en": "New donation",
    "vi": "Tạo quyên góp mới",
  },
  "receive-text": {
    "en": "Receive",
    "vi": "Nhận",
  },
  "edit-donation-title": {
    "en": "Edit donation",
    "vi": "Chỉnh sửa quyên góp",
  },
  "donation-detail-title": {
    "en": "Donation detail",
    "vi": "Thông tin quyên góp",
  },
  "food-type-title": {
    "en": "Food category",
    "vi": "Loại thực phẩm",
  },
  "food-title-title": {
    "en": "Food title",
    "vi": "Tiêu đề món ăn",
  },
  "food-quantity-title": {
    "en": "Quantity",
    "vi": "Số lượng",
  },
  "remove-text": {
    "en": "Remove",
    "vi": "Xoá",
  },
  "remove-recipient-success-text": {
    "en": "Remove success",
    "vi": "Xoá thành công",
  },
  "remove-recipient-confirm-title": {
    "en": "Confirm remove",
    "vi": "Xác nhận xoá",
  },
  "remove-recipient-confirm-content": {
    "en": "Are you sure to remove this recipient from your donation?",
    "vi": "Bạn có chắc muốn xoá người dùng này khỏi quyên góp?",
  },
  "remove-recipient-success-description": {
    "en": "Remove recipient from donation success",
    "vi": "Xoá người nhận khỏi quyên góp thành công",
  },
  "removing-recipient-text": {
    "en": "Removing recipient...",
    "vi": "Đang xoá người nhận... ",
  },
  "food-unit-title": {
    "en": "Unit",
    "vi": "Đơn vị",
  },
  "edit-button-title": {
    "en": "Edit",
    "vi": "Chỉnh sửa",
  },
  "review-button-title": {
    "en": "Write review",
    "vi": "Viết đánh giá",
  },
  "review-button-text": {
    "en": "Reviews",
    "vi": "Đánh giá",
  },
  "no-delete-donation-text": {
    "en": "No deleted donation found",
    "vi": "Không có quyên góp nào bị xoá",
  },
  "review-donation-success-text": {
    "en": "Review success",
    "vi": "Đã đánh giá",
  },
  "review-donation-success-description": {
    "en": "You review has been submitted",
    "vi": "Đánh giá của bạn đã được ghi nhận",
  },
  "quantity-left-text": {
    "en": (value, unit) => "$value $unit left",
    "vi": (value, unit) => "còn $value $unit",
  },
  "time-remaining-title": {
    "en": "Time remaning",
    "vi": "Thời gian còn lại",
  },
  "time-remaining-text": {
    "en": (days, hours, minutes, seconds) {
      String rs = '';
      String pad(time, unit) =>
          '${rs.isEmpty ? "" : ", "}${time.toString().padLeft(2, '0')} $unit${time > 1 ? "s" : ""}';
      if (days > 0) {
        rs += '${days.toString().padLeft(2, '0')} day${days > 1 ? "s" : ""}';
        return rs;
      }
      if (hours > 0) {
        rs += pad(hours, 'hour');
        return hours;
      }
      if (minutes > 0) {
        rs += pad(minutes, 'minute');
      }
      if (seconds > 0 || minutes > 0) {
        rs += pad(seconds, 'second');
      }
      return rs.isEmpty ? "Donation has ended" : rs;
    },
    "vi": (days, hours, minutes, seconds) {
      String rs = '';
      String pad(time, unit) =>
          '${rs.isEmpty ? "" : ", "}${time.toString().padLeft(2, '0')} $unit';

      if (days > 0) {
        rs += '${days.toString().padLeft(2, '0')} ngày';
        return rs;
      }
      if (hours > 0) {
        rs += pad(hours, 'giờ');
        return hours;
      }
      if (minutes > 0) {
        rs += pad(minutes, 'phút');
      }
      if (seconds > 0 || minutes > 0) {
        rs += pad(seconds, 'giây');
      }
      return rs.isEmpty ? "Donation has ended" : rs;
    },
  },
  "food-start-date-title": {
    "en": "Start",
    "vi": "Bắt đầu",
  },
  "donation-route-title": {
    "en": "View route",
    "vi": "Xem lộ trình",
  },
  "loading-user-info-text": {
    "en": "Loading info...",
    "vi": "Đang tải thông tin...",
  },
  "getting-current-location-text": {
    "en": "Getting current location...",
    "vi": "Đang tải vị trí hiện tại...",
  },
  "no-review-text": {
    "en": "No review yet",
    "vi": "Chưa có đánh giá nào",
  },
  "show-on-map-text": {
    "en": "Show on map",
    "vi": "Xem trên bản đồ",
  },
  "order-by-text": {
    "en": "Order by",
    "vi": "Sắp xếp theo",
  },
  "no-image-text": {
    "en": "This donation has no image",
    "vi": "Quyên góp này không có hình ảnh",
  },
  "loading-route-text": {
    "en": "Loading route...",
    "vi": "Đang tạo lộ trình...",
  },
  "donation-has-not-start-yet-text": {
    "en": "The donation hasn't started yet",
    "vi": "Quyên góp chưa bắt đầu",
  },
  "address-title": {
    "en": "Address",
    "vi": "Địa chỉ",
  },
  "food-end-date-title": {
    "en": "End",
    "vi": "Kết thúc",
  },
  "food-photo-title": {
    "en": "Photo",
    "vi": "Ảnh",
  },
  "food-type-grocery": {
    "en": "Grocery",
    "vi": "Tạp hoá",
  },
  "food-type-cooked": {
    "en": "Cooked",
    "vi": "Nấu sẵn",
  },
  "food-type-fruits": {
    "en": "Fruits",
    "vi": "Trái cây",
  },
  "food-type-beverage": {
    "en": "Beverage",
    "vi": "Đồ uống",
  },
  "pickup-instruction-text": {
    "en": "Pickup instruction",
    "vi": "Hướng dẫn lấy hàng",
  },
  "numberic-error-text": {
    "en": "This field must be number",
    "vi": "Trường này phải là chữ số",
  },
  "confirm-button-title": {
    "en": "Confirm",
    "vi": "Xác nhận",
  },
  "delete-donation-confirm-title": {
    "en": "Confirm delete",
    "vi": "Xác nhận xoá",
  },
  "delete-donation-confirm-content": {
    "en": "Are you sure want to delete this donation?",
    "vi": "Bạn có chắc muốn xoá quyên góp này?",
  },
  "soft-delete-donation-confirm-content": {
    "en": "Are you sure want to move this donation to trash bin?",
    "vi": "Bạn có chắc muốn chuyển quyên góp này vào thùng rác?",
  },
  "invalid-datetime-error-text": {
    "en": "End time must be after start time",
    "vi": "Thời gian kết thúc phải ở sau thời gian bắt đầu",
  },
  "address-hint-text": {
    "en": "Pick or seach for your location on the map",
    "vi": "Chọn hoặc tìm địa chỉ của bạn trên bản đồ",
  },
  "radius-title": {
    "en": "Radius",
    "vi": "Bán kính",
  },
  "distance-title": {
    "en": "Distance",
    "vi": "Khoảng cách",
  },
  "find-donation-title": {
    "en": "Find donation",
    "vi": "Tìm quyên góp",
  },
  "available-donation-text": {
    "en": "Available donation",
    "vi": "Quyên góp",
  },
  "register-success-text": {
    "en": "Register success",
    "vi": "Đăng ký hoàn tất",
  },
  "update-donation-success-text": {
    "en": "Update donation success",
    "vi": "Cập nhật thành công",
  },
  "updating-donation-text": {
    "en": "Updating donation...",
    "vi": "Đang cập nhật quyên góp...",
  },
  "register-success-description": {
    "en": "Press OK to return to login screen",
    "vi": "Nhấn OK để trở về màn hình đăng nhập",
  },
  "max-number-of-image-notification": {
    "en": "Max number of image is",
    "vi": "Giới hạn số ảnh là",
  },
  "new-donation-success-text": {
    "en": "Donation created",
    "vi": "Đã tạo quyên góp",
  },
  "creating-donation-text": {
    "en": "Creating new donation...",
    "vi": "Đang tạo quyên góp mới...",
  },
  "network-error": {
    "en": "Network error, please check your network connection",
    "vi": "Lỗi kết nối, vui lòng kiểm tra kết nối mạng của bạn",
  },
  "new-donation-success-description": {
    "en": "Press OK to return to home screen",
    "vi": "Nhấn OK để trở về trang chủ",
  },
  "cancel-text": {
    "en": "Cancel",
    "vi": "Huỷ",
  },
  "delete-text": {
    "en": "Delete",
    "vi": "Xoá",
  },
  "restoring-text": {
    "en": "Restoring...",
    "vi": "Đang phục hồi...",
  },
  "deleted-donation-text": {
    "en": "Deleted donation",
    "vi": "Quyên góp đã xoá",
  },
  "restore-text": {
    "en": "Restore",
    "vi": "Phục hồi",
  },
  "choose-image-text": {
    "en": "Choose image",
    "vi": "Chọn ảnh",
  },
  "deleting-text": {
    "en": "Deleting...",
    "vi": "Đang xoá...",
  },
  "trash-bin-title": {
    "en": "Trash bin",
    "vi": "Thùng rác",
  },
  "delete-donation-success-text": {
    "en": "Deleted",
    "vi": "Đã xoá",
  },
  "delete-donation-success-description": {
    "en": "Donation has been deleted",
    "vi": "Quyên góp đã bị xoá",
  },
  "soft-delete-donation-success-description": {
    "en": "Donation has been moved to trash bin",
    "vi": "Quyên góp đã được đưa vào thùng rác",
  },
  "restore-donation-success-text": {
    "en": "Restored",
    "vi": "Đã phục hồi",
  },
  "restore-donation-success-description": {
    "en": "Donation has been restored",
    "vi": "Quyên góp đã được phục hồi",
  },
  "error-text": {
    "en": "Error",
    "vi": "Lỗi",
  },
  "choose-role-title": {
    "en": "Tell us about you",
    "vi": "Cho chúng tôi biết về bạn",
  },
  "choose-role-description": {
    "en": "Choose one",
    "vi": "Chọn một trong hai",
  },
  "next-button-title": {
    "en": "Next",
    "vi": "Tiếp tục",
  },
  "save-button-title": {
    "en": "Save",
    "vi": "Lưu",
  },
  "donor-text": {
    "en": "Donor",
    "vi": "Người cho",
  },
  "donor-description": {
    "en": "Donate your food for needy",
    "vi": "Quyên góp thực phẩm của bạn cho người cần",
  },
  "recipient-text": {
    "en": "Recipient",
    "vi": "Người nhận",
  },
  "gallery-text": {
    "en": "Gallery",
    "vi": "Thư viện",
  },
  "recipient-description": {
    "en": "Receive food from Donor",
    "vi": "Nhận thức ăn từ người cho",
  },
  "forgot-password-title": {
    "en": "Forgot password?",
    "vi": "Quên mật khẩu?",
  },
  "send-email-success-text": {
    "en": "Email sent",
    "vi": "Đã gửi email",
  },
  "send-email-success-description": {
    "en": "Please check your inbox and follow instruction",
    "vi": "Vui lòng kiểm tra hộp thư của bạn và làm theo hướng dẫn",
  },
  "login-with-facebook-button-title": {
    "en": "Continue with Facebook",
    "vi": "Tiếp tục với Facebook",
  },
  "login-with-google-button-title": {
    "en": "Continue with Google",
    "vi": "Tiếp tục với Google",
  },
  "required-error-text": {
    "en": "This field can not be empty",
    "vi": "Trường này không được để trống",
  },
  "email-error-text": {
    "en": "This field requires a valid email address",
    "vi": "Cần nhập địa chỉ email hợp lệ",
  },
  "min-length-error-text": {
    "en": "Minimum length is ",
    "vi": "Độ dài tối thiểu là ",
  },
  "max-length-error-text": {
    "en": "Maximum length is ",
    "vi": "Độ dài tối đa là ",
  },
  "wrong-password": {
    "en": "Wrong password",
    "vi": "Mật khẩu sai",
  },
  "wrong-password-description": {
    "en": "The password is invalid or the user does not have a password.",
    "vi": "Mật khẩu không đúng hoặc người dùng không có mật khẩu.",
  },
  "email-already-in-use": {
    "en": "Email already in use",
    "vi": "Email đã được sử dụng",
  },
  "email-already-in-use-description": {
    "en": "The email address is already in use by another account.",
    "vi": "Địa chỉ email đã được sử dụng bởi tài khoản khác.",
  },
  "user-not-found": {
    "en": "User not found",
    "vi": "Người dùng không tồn tại",
  },
  "user-not-found-description": {
    "en":
        "There is no user record corresponding to this identifier. The user may have been deleted.",
    "vi":
        "Không có bản ghi người dùng nào tương ứng với số nhận dạng này. Người dùng có thể đã bị xóa.",
  },
  "home-title": {
    "en": "Home",
    "vi": "Trang chủ",
  },
  "profile-title": {
    "en": "Profile",
    "vi": "Tài khoản",
  },
  "setting-title": {
    "en": "Settings",
    "vi": "Cài đặt",
  },
  "logout-title": {
    "en": "Logout",
    "vi": "Đăng xuất",
  },
  "general-setting-label": {
    "en": "General",
    "vi": "Chung",
  },
  "notifications-text": {
    "en": "Notifications",
    "vi": "Thông báo",
  },
  "welcome-back-text": {
    "en": "Welcome back !",
    "vi": "Chào mừng quay lại !",
  },
  "update-display-name-success-text": {
    "en": "Username updated",
    "vi": "Đã cập nhật tên",
  },
  "update-display-name-success-description": {
    "en": "Update username success",
    "vi": "Cập nhật tên người dùng thành công",
  },
  "update-phone-number-success-text": {
    "en": "Phone number updated",
    "vi": "Đã cập nhật số điện thoại",
  },
  "update-phone-number-success-description": {
    "en": "Update phone number success",
    "vi": "Cập nhật số điện thoại thành công",
  },
  "update-email-success-text": {
    "en": "Email updated",
    "vi": "Đã cập nhật email",
  },
  "update-email-success-description": {
    "en": "Update email success",
    "vi": "Cập nhật email thành công",
  },
  "updating-text": {
    "en": "Updating...",
    "vi": "Đang cập nhật...",
  },
  "edit-username-title": {
    "en": "Edit username",
    "vi": "Cập nhật tên người dùng",
  },
  "edit-phone-number-title": {
    "en": "Edit phone number",
    "vi": "Cập nhật số điện thoại",
  },
  "edit-email-title": {
    "en": "Edit email",
    "vi": "Cập nhật email",
  },
  "recipients-button-text": {
    "en": "Recipients",
    "vi": "Người nhận",
  },
  "no-recipient-text": {
    "en": "No recipient yet",
    "vi": "Chưa có người nhận nào",
  },
  "donations-stats-label": {
    "en": "DONATIONS",
    "vi": "QUYÊN GÓP",
  },
  "received-donations-stats-label": {
    "en": "DONATIONS RECEIVED",
    "vi": "QUYÊN GÓP ĐÃ NHẬN",
  },
  "update-avatar-success-text": {
    "en": "Updated",
    "vi": "Đã cập nhật",
  },
  "update-avatar-success-description": {
    "en": "Update avatar success",
    "vi": "Cập nhật ảnh đại diện thành công",
  },
  "recipients-stats-label": {
    "en": "RECIPIENTS",
    "vi": "NGƯỜI NHẬN",
  },
  "rating-stats-label": {
    "en": "RATING",
    "vi": "ĐÁNH GIÁ",
  },
  "monthly-donation-text-donor": {
    "en": (total) =>
        "You've created $total donation${total > 1 ? 's' : ''} this month.",
    "vi": (total) => "Bạn đã tạo $total quyên góp trong tháng này.",
  },
  "monthly-donation-text-recipient": {
    "en": (total) =>
        "You've received $total donation${total > 1 ? 's' : ''} this month.",
    "vi": (total) => "Bạn đã nhận $total quyên góp trong tháng này.",
  },
  "language-setting-text": {
    "en": "Language",
    "vi": "Ngôn ngữ",
  },
  "donation-ended-text": {
    "en": "Donation has ended",
    "vi": "Đã quá thời gian nhận quyên góp",
  },
  "choose-location-title": {
    "en": "Choose location",
    "vi": "Chọn vị trí",
  },
  "choose-your-location-title": {
    "en": "Choose your location",
    "vi": "Chọn vị trí của bạn",
  },
  "donation-history-text-donor": {
    "en": "Donation history",
    "vi": "Lịch sử quyên góp",
  },
  "donation-history-text-recipient": {
    "en": "Receiced donation",
    "vi": "Quyên góp đã nhận",
  },
  "donor-notification-title-part-1": {
    "en": "Your donation",
    "vi": "Đóng góp",
  },
  "donor-notification-title-part-2": {
    "en": "has new recipient",
    "vi": "của bạn có người nhận mới",
  },
};
