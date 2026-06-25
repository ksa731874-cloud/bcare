<?php
// 1. تفعيل عرض الأخطاء بالكامل في هذا الملف المستقل
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// 2. استدعاء ملفك الأساسي لرؤية أين ينهار بالضبط
include('index-details.php');