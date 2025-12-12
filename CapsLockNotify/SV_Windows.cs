using Microsoft.Toolkit.Uwp.Notifications;

namespace CapsLockNotify;

public partial class SV_Windows {
  /// <summary>
  /// Windows 通知
  /// </summary>
  public class Toast {
    /// <summary>
    /// 顯示 Windows 通知
    /// </summary>
    /// <param name="text"></param>
    /// <param name="title"></param>
    /// <param name="uri"></param>
    public static void Show(string? text = null, string? title = null, Uri? uri = null) {
      var toastBuilder = new ToastContentBuilder();

      if (title is not null) {
        toastBuilder.AddText(title);
      }

      if (text is not null) {
        toastBuilder.AddText(text);
      }

      if (uri is not null) {
        toastBuilder.AddInlineImage(uri);
      }

      toastBuilder.Show(x => x.ExpirationTime = DateTimeOffset.Now.AddSeconds(3));
    }
  }
}
