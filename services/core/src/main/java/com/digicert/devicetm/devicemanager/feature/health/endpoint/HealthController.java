package com.digicert.devicetm.devicemanager.feature.health.endpoint;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/devicetrustmanager/device-manager/api/v1/health")
public class HealthController {

    @GetMapping("/heartbeat")
    public ResponseEntity<Void> health() {
        return ResponseEntity.ok().build();
    }

    @GetMapping("/basic")
    @ResponseStatus(HttpStatus.OK)
    public Map<String, String> basic() {
        return Collections.singletonMap("STATUS", "OK");
    }
}
