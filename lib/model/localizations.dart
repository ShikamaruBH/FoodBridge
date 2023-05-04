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
  "no-data-text": {
    "en": "You haven't made any donation yet.",
    "vi": "Bạn chưa có quyên góp nào.",
  },
  "new-donation-title": {
    "en": "New donation",
    "vi": "Tạo quyên góp mới",
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
  "food-unit-title": {
    "en": "Unit",
    "vi": "Đơn vị",
  },
  "edit-button-title": {
    "en": "Edit",
    "vi": "Chỉnh sửa",
  },
  "rate-button-title": {
    "en": "Rating",
    "vi": "Đánh giá",
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
      }
      if (minutes > 0) {
        rs += pad(minutes, 'minute');
      }
      if (seconds > 0) {
        rs += pad(seconds, 'second');
      }
      return rs;
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
      }
      if (minutes > 0) {
        rs += pad(minutes, 'phút');
      }
      if (seconds > 0) {
        rs += pad(seconds, 'giây');
      }
      return rs;
    },
  },
  "food-start-date-title": {
    "en": "Start",
    "vi": "Bắt đầu",
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
  "address-hint-text": {
    "en": "Pick or seach for your location on the map",
    "vi": "Chọn hoặc tìm địa chỉ của bạn trên bản đồ",
  },
  "register-success-text": {
    "en": "Register success",
    "vi": "Đăng ký hoàn tất",
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
  "new-donation-success-description": {
    "en": "Press OK to return to home screen",
    "vi": "Nhấn OK để trở về trang chủ",
  },
  "cancel-text": {
    "en": "Cancel",
    "vi": "Huỷ",
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
  "account-title": {
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
  "monthly-donation-text": {
    "en": (total) =>
        "You've created $total donation${total > 1 ? 's' : ''} this month.",
    "vi": (total) => "Bạn đã tạo $total quyên góp trong tháng này.",
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
  "donation-history-text": {
    "en": "Donation history",
    "vi": "Lịch sử quyên góp",
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
