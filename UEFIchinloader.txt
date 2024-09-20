#include <Uefi.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/PrintLib.h>
#include <Protocol/LoadedImage.h>

EFI_STATUS
EFIAPI
UefiMain(
    IN EFI_HANDLE ImageHandle,
    IN EFI_SYSTEM_TABLE *SystemTable
) {
    EFI_STATUS Status;
    EFI_HANDLE *HandleBuffer;
    UINTN HandleCount;
    UINTN Index;

    // Locate all loaded images
    Status = gBS->LocateHandleBuffer(ByProtocol, &gEfiLoadedImageProtocolGuid, NULL, &HandleCount, &HandleBuffer);
    if (EFI_ERROR(Status)) {
        Print(L"Failed to locate loaded images.\n");
        return Status;
    }

    // Display the name of the boot manager
    Print(L"Welcome to ChinLoader!\n");
    Print(L"Detected Operating Systems:\n");

    // Iterate through loaded images and identify OS
    for (Index = 0; Index < HandleCount; Index++) {
        EFI_LOADED_IMAGE_PROTOCOL *LoadedImage;
        Status = gBS->HandleProtocol(HandleBuffer[Index], &gEfiLoadedImageProtocolGuid, (VOID **)&LoadedImage);
        if (EFI_ERROR(Status)) {
            continue;
        }

        // Check for specific OS signatures by path
        if (StrStr(LoadedImage->FilePath, L"\\EFI\\Microsoft\\Boot\\") != NULL) {
            Print(L"  Windows OS detected at %s\n", LoadedImage->FilePath);
        } else if (StrStr(LoadedImage->FilePath, L"\\EFI\\ubuntu\\") != NULL) {
            Print(L"  Ubuntu OS detected at %s\n", LoadedImage->FilePath);
        } else if (StrStr(LoadedImage->FilePath, L"\\EFI\\Apple\\") != NULL) {
            Print(L"  macOS detected at %s\n", LoadedImage->FilePath);
        } else if (StrStr(LoadedImage->FilePath, L"\\EFI\\arch\\") != NULL) {
            Print(L"  Arch Linux detected at %s\n", LoadedImage->FilePath);
        } else if (StrStr(LoadedImage->FilePath, L"\\EFI\\kali\\") != NULL) {
            Print(L"  Kali Linux detected at %s\n", LoadedImage->FilePath);
        }
    }

    // Optionally, prompt user to select an OS and boot it
    // This part would involve setting up a simple input loop

    return EFI_SUCCESS;
}
