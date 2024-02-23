<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TodoController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

// Route::get('/', function () {
//     return view('welcome');
// });



// Route::resource('/', \App\Http\Controllers\TodoController::class);
// Route::get('todos/{todo}', [\App\Http\Controllers\TodoController::class,'destroy'])->name('todos.destroy');

Route::get('/', [TodoController::class, 'index'])->name('index');
Route::get('/create', [TodoController::class, 'create']);
Route::post('/store', [TodoController::class, 'store'])->name('store');
Route::get('/edit/{id}', [TodoController::class, 'edit'])->name('/edit');
Route::put('/update/{id}', [TodoController::class, 'update'])->name('/update');
Route::get('/destroy/{id}', [TodoController::class, 'destroy'])->name('/destroy');
