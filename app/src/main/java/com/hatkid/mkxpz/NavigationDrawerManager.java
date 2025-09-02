package com.hatkid.mkxpz;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.view.MenuItem;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.documentfile.provider.DocumentFile;
import androidx.drawerlayout.widget.DrawerLayout;

import com.google.android.material.navigation.NavigationView;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;

public class NavigationDrawerManager {

    private enum FileActionType { BACKUP, RESTORE }
    private FileActionType pendingActionType = FileActionType.BACKUP;
    private ActivityResultLauncher<Intent> folderPickerLauncher;
    private final MainActivity activity; // To access context, contentResolver, etc.

    public NavigationDrawerManager(MainActivity activity) {
        this.activity = activity;
        this.folderPickerLauncher = activity.registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                result -> {
                    if (result.getResultCode() == Activity.RESULT_OK) {
                        Intent data = result.getData();
                        if (data != null) {
                            Uri treeUri = data.getData();
                            if (treeUri != null) {
                                // Persist access
                                activity.getContentResolver().takePersistableUriPermission(
                                        treeUri,
                                        Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                                );

                                if (pendingActionType == FileActionType.BACKUP) {
                                    backupToUri(treeUri);
                                } else if (pendingActionType == FileActionType.RESTORE) {
                                    restoreFromUri(treeUri);
                                    Toast.makeText(activity, "Successful restore. Please restart the application.", Toast.LENGTH_LONG).show();
                                    activity.finish();
                                }
                            }
                        }
                    }
                }
        );
    }

    public void setupNavigationDrawer() {
        DrawerLayout drawer = activity.findViewById(R.id.drawer_layout);
        NavigationView navigationView = activity.findViewById(R.id.nav_view);

        if (navigationView != null && drawer != null) {
            navigationView.setNavigationItemSelectedListener(new NavigationView.OnNavigationItemSelectedListener() {
                @Override
                public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                    int id = item.getItemId();
                    if (id == R.id.nav_backup) {
                        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
                        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION |
                                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION |
                                        Intent.FLAG_GRANT_PREFIX_URI_PERMISSION |
                                        Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
                        pendingActionType = FileActionType.BACKUP;
                        folderPickerLauncher.launch(intent);
                    } else if (id == R.id.nav_restore) {
                        Log.d("DrawerClick", "Restore clicked in NavigationDrawerManager");
                        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
                        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION |
                                        Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION |
                                        Intent.FLAG_GRANT_PREFIX_URI_PERMISSION);
                        pendingActionType = FileActionType.RESTORE;
                        folderPickerLauncher.launch(intent);
                    }

                    drawer.closeDrawers();
                    return true;
                }
            });
        } else {
            Log.e("NavDrawerManager", "NavigationView or DrawerLayout not found.");
        }
    }

    private void backupToUri(Uri treeUri) {
        File sourceDir = activity.getFilesDir();
        DocumentFile pickedDir = DocumentFile.fromTreeUri(activity, treeUri);

        if (pickedDir == null || !pickedDir.isDirectory()) {
            Toast.makeText(activity, "Invalid directory selected", Toast.LENGTH_SHORT).show();
            return;
        }

        try {
            File[] files = sourceDir.listFiles();
            if (files == null) {
                Toast.makeText(activity, "No files to backup", Toast.LENGTH_SHORT).show();
                return;
            }

            for (File file : files) {
                if (file.isFile()) { // Ensure we only backup files
                    DocumentFile targetFile = pickedDir.createFile("application/octet-stream", file.getName());
                    if (targetFile == null) {
                        Log.e("Backup", "Failed to create target file: " + file.getName());
                        continue; // Skip this file
                    }
                    try (InputStream in = new FileInputStream(file);
                         OutputStream out = activity.getContentResolver().openOutputStream(targetFile.getUri())) {
                        if (out == null) {
                            Log.e("Backup", "Failed to open output stream for: " + targetFile.getUri());
                            continue; // Skip this file
                        }
                        byte[] buffer = new byte[4096];
                        int len;
                        while ((len = in.read(buffer)) > 0) {
                            out.write(buffer, 0, len);
                        }
                    }
                }
            }
            Toast.makeText(activity, "Backup successful", Toast.LENGTH_SHORT).show();
        } catch (Exception e) {
            Log.e("Backup", "Backup failed", e);
            Toast.makeText(activity, "Backup failed: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }

    private void restoreFromUri(Uri sourceTreeUri) {
        DocumentFile sourceRoot = DocumentFile.fromTreeUri(activity, sourceTreeUri);
        File targetRoot = activity.getFilesDir();

        if (sourceRoot == null || !sourceRoot.isDirectory()) {
            Toast.makeText(activity, "Invalid restore source directory", Toast.LENGTH_SHORT).show();
            return;
        }

        copyDirectoryRecursive(sourceRoot, targetRoot);
        Toast.makeText(activity, "Restore complete", Toast.LENGTH_SHORT).show();
    }

    private void copyDirectoryRecursive(DocumentFile sourceDir, File targetDir) {
        if (!targetDir.exists()) {
            if (!targetDir.mkdirs()) {
                Log.e("Restore", "Failed to create target directory: " + targetDir.getPath());
                Toast.makeText(activity, "Failed to create directory: " + targetDir.getName(), Toast.LENGTH_SHORT).show();
                return;
            }
        }

        for (DocumentFile docFile : sourceDir.listFiles()) {
            File targetFile = new File(targetDir, docFile.getName());

            if (docFile.isDirectory()) {
                copyDirectoryRecursive(docFile, targetFile);
            } else if (docFile.isFile()) {
                try (InputStream in = activity.getContentResolver().openInputStream(docFile.getUri());
                     OutputStream out = Files.newOutputStream(targetFile.toPath())) {
                    if (in == null) {
                        Log.e("Restore", "Failed to open input stream for: " + docFile.getUri());
                        continue; // Skip this file
                    }
                    byte[] buffer = new byte[4096];
                    int len;
                    while ((len = in.read(buffer)) > 0) {
                        out.write(buffer, 0, len);
                    }
                } catch (IOException e) {
                    Log.e("Restore", "Failed to restore file: " + docFile.getName(), e);
                    Toast.makeText(activity, "Failed to restore " + docFile.getName(), Toast.LENGTH_SHORT).show();
                }
            }
        }
    }
}
