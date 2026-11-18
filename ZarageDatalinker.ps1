
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms

# ============================================================
# SELECTOR MODERNO DE CARPETAS DE WINDOWS 11
# ============================================================

if (-not ("ModernFolderPicker" -as [type])) {

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

[ComImport]
[Guid("DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7")]
class FileOpenDialog { }

[ComImport]
[Guid("D57C7288-D4AD-4768-BE02-9D969532D960")]
[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IFileDialog
{
    [PreserveSig] int Show(IntPtr parent);
    void SetFileTypes(uint count, IntPtr types);
    void SetFileTypeIndex(uint index);
    void GetFileTypeIndex(out uint index);
    void Advise(IntPtr events, out uint cookie);
    void Unadvise(uint cookie);
    void SetOptions(uint options);
    void GetOptions(out uint options);
    void SetDefaultFolder(IntPtr folder);
    void SetFolder(IntPtr folder);
    void GetFolder(out IntPtr folder);
    void GetCurrentSelection(out IntPtr item);
    void SetFileName([MarshalAs(UnmanagedType.LPWStr)] string name);
    void GetFileName(out IntPtr name);
    void SetTitle([MarshalAs(UnmanagedType.LPWStr)] string title);
    void SetOkButtonLabel([MarshalAs(UnmanagedType.LPWStr)] string text);
    void SetFileNameLabel([MarshalAs(UnmanagedType.LPWStr)] string label);
    void GetResult(out IShellItem item);
}

[ComImport]
[Guid("43826D1E-E718-42EE-BC55-A1E261C37BFE")]
[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IShellItem
{
    void BindToHandler();
    void GetParent();
    void GetDisplayName(uint sigdnName, out IntPtr name);
}

public class ModernFolderPicker
{
    public static string Select(string title)
    {
        IFileDialog dialog = (IFileDialog)new FileOpenDialog();

        try
        {
            uint options;
            dialog.GetOptions(out options);

            // Seleccionar carpetas + forzar rutas del sistema de archivos
            dialog.SetOptions(options | 0x20 | 0x40);

            dialog.SetTitle(title);
            dialog.SetOkButtonLabel("Seleccionar carpeta");

            int result = dialog.Show(IntPtr.Zero);

            // Cancelado por el usuario
            if (result != 0)
                return null;

            IShellItem item;
            dialog.GetResult(out item);

            try
            {
                IntPtr path;
                item.GetDisplayName(0x80058000, out path);

                try
                {
                    return Marshal.PtrToStringUni(path);
                }
                finally
                {
                    Marshal.FreeCoTaskMem(path);
                }
            }
            finally
            {
                Marshal.ReleaseComObject(item);
            }
        }
        finally
        {
            Marshal.ReleaseComObject(dialog);
        }
    }
}
"@ -Language CSharp

}

# ============================================================
# INTERFAZ XAML
# ============================================================

[xml]$xaml = @'
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ZARAGE DATALINKER // Gestor de Enlaces Simbolicos" Height="440" Width="600"
        WindowStartupLocation="CenterScreen" ResizeMode="CanResize"
        Background="#121212" Foreground="#F5F5F5">
    
    <Window.Resources>

        <!-- Estilo para los campos de texto -->
        <Style x:Key="GoldTextBox" TargetType="TextBox">
            <Setter Property="Background" Value="#1A1A1A"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="#4A3F1E"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="10,8"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="6">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Estilo para los botones de explorar -->
        <Style x:Key="GoldOutlineButton" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#D4AF37"/>
            <Setter Property="BorderBrush" Value="#D4AF37"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border"
                                Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="6">
                            <ContentPresenter HorizontalAlignment="Center"
                                              VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border"
                                        Property="Background"
                                        Value="#26200D"/>
                                <Setter Property="Foreground" Value="#F3E5AB"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

    </Window.Resources>

    <Grid Margin="30">

        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <!-- Titulo y Subtitulo -->
        <StackPanel Grid.Row="0" Margin="0,0,0,25">
            <TextBlock Text="ZARAGE DATALINKER"
                       FontSize="24"
                       FontWeight="Bold"
                       Foreground="#D4AF37"
                       FontFamily="Segoe UI"/>

            <TextBlock Text="Mueve carpetas pesadas a otro disco y enlazalas con mklink /J"
                       FontSize="13"
                       Foreground="#888888"
                       Margin="0,4,0,0"
                       FontFamily="Segoe UI"/>
        </StackPanel>

        <!-- Campo 1: Origen -->
        <StackPanel Grid.Row="1" Margin="0,0,0,18">

            <TextBlock Text="1. CARPETA ORIGINAL (Ej: en AppData)"
                       FontSize="12"
                       FontWeight="Bold"
                       Foreground="#D4AF37"
                       Margin="0,0,0,6"/>

            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="100"/>
                </Grid.ColumnDefinitions>

                <TextBox x:Name="txtSource"
                         Grid.Column="0"
                         Style="{StaticResource GoldTextBox}"
                         Margin="0,0,12,0"/>

                <Button x:Name="btnSource"
                        Grid.Column="1"
                        Content="Explorar"
                        Style="{StaticResource GoldOutlineButton}"
                        Height="40"/>
            </Grid>
        </StackPanel>

        <!-- Campo 2: Destino -->
        <StackPanel Grid.Row="2" Margin="0,0,0,25">

            <TextBlock Text="2. NUEVA UBICACION (Disco secundario)"
                       FontSize="12"
                       FontWeight="Bold"
                       Foreground="#D4AF37"
                       Margin="0,0,0,6"/>

            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="100"/>
                </Grid.ColumnDefinitions>

                <TextBox x:Name="txtDest"
                         Grid.Column="0"
                         Style="{StaticResource GoldTextBox}"
                         Margin="0,0,12,0"/>

                <Button x:Name="btnDest"
                        Grid.Column="1"
                        Content="Explorar"
                        Style="{StaticResource GoldOutlineButton}"
                        Height="40"/>
            </Grid>
        </StackPanel>

        <!-- Boton Principal con Degradado Dorado -->
        <Button x:Name="btnExecute"
                Grid.Row="3"
                Height="48"
                Cursor="Hand"
                BorderThickness="0">

            <Button.Template>
                <ControlTemplate TargetType="Button">
                    <Border CornerRadius="8">
                        <Border.Background>
                            <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                                <GradientStop Color="#C59B27" Offset="0.0"/>
                                <GradientStop Color="#E6CA65" Offset="0.5"/>
                                <GradientStop Color="#B38A1E" Offset="1.0"/>
                            </LinearGradientBrush>
                        </Border.Background>

                        <ContentPresenter HorizontalAlignment="Center"
                                          VerticalAlignment="Center"/>
                    </Border>
                </ControlTemplate>
            </Button.Template>

            <TextBlock Text="MOVER CARPETA Y CREAR ENLACE"
                       FontWeight="Bold"
                       FontSize="14"
                       Foreground="#0D0D0D"/>
        </Button>

    </Grid>
</Window>
'@

# ============================================================
# CARGAR VENTANA
# ============================================================

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$txtSource = $window.FindName("txtSource")
$txtDest = $window.FindName("txtDest")
$btnSource = $window.FindName("btnSource")
$btnDest = $window.FindName("btnDest")
$btnExecute = $window.FindName("btnExecute")

# ============================================================
# FUNCION: SELECTOR MODERNO DE CARPETAS
# ============================================================

function Select-ModernFolder {
    param([string]$DialogTitle)

    try {
        return [ModernFolderPicker]::Select($DialogTitle)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "No se pudo abrir el selector de carpetas:`n$_",
            "Error del explorador",
            0,
            16
        )
        return $null
    }
}

# ============================================================
# BOTON: SELECCIONAR CARPETA ORIGINAL
# ============================================================

$btnSource.Add_Click({

    $selected = Select-ModernFolder -DialogTitle "Selecciona la carpeta original"

    if ($selected) {
        $txtSource.Text = $selected
    }

})

# ============================================================
# BOTON: SELECCIONAR CARPETA DE DESTINO
# ============================================================

$btnDest.Add_Click({

    $selected = Select-ModernFolder -DialogTitle "Selecciona la carpeta de destino"

    if ($selected) {
        $txtDest.Text = $selected
    }

})

# ============================================================
# BOTON PRINCIPAL: MOVER Y CREAR MKLINK /J
# ============================================================

$btnExecute.Add_Click({

    $src = $txtSource.Text.Trim()
    $dstBase = $txtDest.Text.Trim()

    # Validar campos
    if (-not $src -or -not $dstBase) {

        [System.Windows.Forms.MessageBox]::Show(
            "Por favor selecciona ambas rutas antes de continuar.",
            "Campos incompletos",
            0,
            48
        )

        return
    }

    # Validar origen
    if (-not (Test-Path -LiteralPath $src -PathType Container)) {

        [System.Windows.Forms.MessageBox]::Show(
            "La carpeta de origen no existe.",
            "Error",
            0,
            16
        )

        return
    }

    # Validar destino base
    if (-not (Test-Path -LiteralPath $dstBase -PathType Container)) {

        [System.Windows.Forms.MessageBox]::Show(
            "La carpeta de destino no existe.",
            "Error",
            0,
            16
        )

        return
    }

    # Obtener nombre de carpeta
    $folderName = Split-Path -Path $src -Leaf

    # Construir ruta final
    $finalDst = Join-Path $dstBase $folderName

    # Evitar sobrescribir carpetas existentes
    if (Test-Path -LiteralPath $finalDst) {

        [System.Windows.Forms.MessageBox]::Show(
            "La carpeta de destino ya existe y contiene archivos.",
            "Error",
            0,
            16
        )

        return
    }

    # Confirmacion
    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "Se moveran todos los archivos de:`n`n$src`n`nHacia:`n`n$finalDst`n`nY se creara el enlace simbolico (mklink /J).`n`nDeseas continuar?",
        "Confirmar operacion",
        4,
        32
    )

    if ($confirm -eq "Yes") {

        $moved = $false

        try {

            # Mover carpeta
            Move-Item -LiteralPath $src -Destination $finalDst -ErrorAction Stop

            $moved = $true

            # Crear enlace de directorio
            $cmd = "mklink /J `"$src`" `"$finalDst`""

            $process = Start-Process cmd.exe `
                -ArgumentList "/c $cmd" `
                -WindowStyle Hidden `
                -Wait `
                -PassThru

            # Comprobar resultado
            if ($process.ExitCode -eq 0) {

                [System.Windows.Forms.MessageBox]::Show(
                    "Carpeta movida y enlace creado con exito!",
                    "Completado",
                    0,
                    64
                )

            }
            else {

                # Restaurar carpeta si falla el enlace
                Move-Item -LiteralPath $finalDst -Destination $src -ErrorAction Stop

                $moved = $false

                [System.Windows.Forms.MessageBox]::Show(
                    "Fallo al crear el enlace. Los archivos se regresaron a su sitio original.",
                    "Error",
                    0,
                    16
                )

            }

        }
        catch {

            $errorMessage = $_.Exception.Message

            # Intentar restaurar si ya se habia movido
            if ($moved -and (Test-Path -LiteralPath $finalDst)) {

                try {

                    if (-not (Test-Path -LiteralPath $src)) {
                        Move-Item -LiteralPath $finalDst -Destination $src -ErrorAction Stop
                    }

                }
                catch {
                    $errorMessage += "`n`nNo se pudo restaurar automaticamente la carpeta: $_"
                }

            }

            [System.Windows.Forms.MessageBox]::Show(
                "Ocurrio un error:`n`n$errorMessage",
                "Error critico",
                0,
                16
            )

        }

    }

})

# ============================================================
# MOSTRAR VENTANA
# ============================================================

[void]$window.ShowDialog()
