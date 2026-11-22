
if (login_state == LoginState.WAITING_BROWSER &&
    flow_id != "") {

    request_status = http_get(
        backend_url + "/auth/status/" + flow_id
    );
}
