using System.ComponentModel;
using Timer = System.Windows.Forms.Timer;
namespace CapsLockNotify;

public partial class Form1 : Form {
  //private readonly ComponentResourceManager resources = new(typeof(Form1));

  private readonly ToolStripMenuItem toolStripMenuItem_Exit = new();
  private readonly Timer timer = new();
  private readonly ContextMenuStrip contextMenuStrip = new();
  private readonly NotifyIcon notifyIcon = new();

  // 存目前 Casp 狀態
  private bool _lastCapsState = IsKeyLocked(Keys.CapsLock);

  public Form1() {
    InitializeComponent();

    components = new Container();

    //Form 設定
    this.Text = "CapsLockNotify";
    //  最小化
    this.WindowState = FormWindowState.Minimized;
    //  不要在工作列顯示
    this.ShowInTaskbar = false;
    //  不要在工作列顯示
    //this.VisibleChanged += (s, e) => Hide();

    // toolStripMenuItem_Exit
    this.toolStripMenuItem_Exit.Name = "toolStripMenuExit";
    this.toolStripMenuItem_Exit.Size = new Size(180, 22);
    this.toolStripMenuItem_Exit.Text = "Exit";
    this.toolStripMenuItem_Exit.Click += (s, e) => Close();

    // timer
    this.timer.Enabled = true;
    this.timer.Tick += new EventHandler(Timer_Tick);

    // notifyIcon
    this.notifyIcon = new NotifyIcon(components);
    this.notifyIcon.ContextMenuStrip = contextMenuStrip;
    this.notifyIcon.Icon = Properties.Resources.capslock_off;
    this.notifyIcon.Visible = true;

    // contextMenuStrip
    this.contextMenuStrip.SuspendLayout();
    this.contextMenuStrip.Items.AddRange([toolStripMenuItem_Exit]);
    this.contextMenuStrip.Size = new Size(181, 48);
    this.contextMenuStrip.ResumeLayout(false);
  }

  private void Timer_Tick(Object? sender, EventArgs e) {
    bool isCaps = IsKeyLocked(Keys.CapsLock);
    bool isShift = ModifierKeys == Keys.Shift;
    // 真正的輸入狀態：CapsLock 與 Shift 會互相反轉
    bool isUpper = isCaps ^ isShift;
    var message = isUpper ? "Caps Lock: ON" : "Caps Lock: OFF";

    notifyIcon.Text = message;
    notifyIcon.Icon = isUpper ? Properties.Resources.capslock_on : Properties.Resources.capslock_off;

    // Caps 改變且不是 shift 才跳 Windows 通知
    if (isCaps != _lastCapsState && !isShift) {
      SV_Windows.Toast.Show(message);
      // 更新 Caps 狀態
      _lastCapsState = isCaps;
    }
  }
}
