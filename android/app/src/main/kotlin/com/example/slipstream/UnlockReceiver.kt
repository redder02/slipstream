package com.example.slipstream

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

class UnlockReceiver : BroadcastReceiver() {

    override fun onReceive(
        context: Context,
        intent: Intent
    ) {
        Toast.makeText(
            context,
            "UNLOCK DETECTED",
            Toast.LENGTH_LONG
        ).show()
    }
}