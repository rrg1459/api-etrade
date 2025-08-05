Claro, esa es una pregunta clave en el flujo de OAuth. En el método `def callback`, el parámetro `oauth_verifier` se obtiene automáticamente porque E*TRADE lo envía a tu URL de retorno (`callback`).

Para entenderlo mejor, aquí está el flujo completo de cómo funciona:

1.  **En tu método `start_auth`**:
    * Tú obtienes un `request_token` de E*TRADE.
    * Le dices al usuario que vaya a la `authorization_url` de E*TRADE, que tiene un aspecto similar a este: `https://us.etrade.com/e/t/etws/authorize?oauth_token=tu_request_token`.
    * En este punto, tú puedes, opcionalmente, decirle a E*TRADE dónde debe redirigir al usuario después de la autorización. Esto se hace con un parámetro llamado `oauth_callback` en la URL del request token. Por ejemplo: `https://apisb.etrade.com/oauth/request_token?oauth_callback=http://tudominio.com/api/etrade/callback`.

2.  **El usuario interactúa con E*TRADE**:
    * El usuario inicia sesión en su cuenta de la sandbox de E*TRADE.
    * E*TRADE le pide al usuario que autorice tu aplicación.
    * Una vez que el usuario da su consentimiento, E*TRADE genera un **PIN de verificación** (`oauth_verifier`).

3.  **La redirección a tu `callback`**:
    * E*TRADE redirige al navegador del usuario a tu URL de retorno (`http://tudominio.com/api/etrade/callback`).
    * En esa URL de redirección, E*TRADE **adjunta** el `oauth_verifier` como un parámetro de la URL. La URL se verá algo así: `http://tudominio.com/api/etrade/callback?oauth_token=tu_request_token&oauth_verifier=123456`.

4.  **Rails y el `callback`**:
    * Cuando Rails recibe esta solicitud, analiza la URL y convierte los parámetros (`oauth_token` y `oauth_verifier`) en un hash llamado `params`.
    * Por lo tanto, en tu método `def callback`, cuando escribes `params[:oauth_verifier]`, Rails simplemente accede al valor del parámetro `oauth_verifier` que E*TRADE incluyó en la URL de redirección.

### Resumen

No necesitas hacer nada más para "obtener" el dato. Si tu ruta de Rails está configurada correctamente y la URL de retorno (`oauth_callback`) que le proporcionaste a E*TRADE es la correcta, el parámetro `oauth_verifier` ya estará disponible en el hash `params` de tu controlador, listo para que lo uses.