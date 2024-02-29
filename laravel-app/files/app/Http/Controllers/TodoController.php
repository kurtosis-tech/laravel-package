<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Todo;


class TodoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $todos=Todo::all();
        return view('todo',compact('todos'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
        $validator = Validator::make($request->all(), [
            'title' => 'required',
        ]);

        if ($validator->fails())
        {
            return redirect()->route('index')->withErrors($validator);
        }

        
        Todo::create([
            'title'=>$request->get('title')
        ]);

               return redirect()->route('index')->with('success', 'Inserted');

    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
        $todo=Todo::where('id',$id)->first();
        return view('edit-todo',compact('todo'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
        $validator = Validator::make($request->all(), [
            'title' => 'required',
        ]);

        if ($validator->fails())
        {
            return redirect()->route('edit',['todo'=>$id])->withErrors($validator);
        }



        $todo=Todo::where('id',$id)->first();
        $todo->title=$request->get('title');
        $todo->is_completed=$request->get('is_completed');
        $todo->save();

        return redirect()->route('index')->with('success', 'Updated Todo');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        //
        Todo::where('id',$id)->delete();
        return redirect()->route('index')->with('success', 'Deleted Todo');
    }
}
