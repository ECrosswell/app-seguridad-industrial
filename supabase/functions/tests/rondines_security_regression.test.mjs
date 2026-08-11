import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const base = readFileSync(
  new URL("../../migrations/20260811183434_rondines_qr_offline.sql", import.meta.url),
  "utf8",
);
const correctiva = readFileSync(
  new URL(
    "../../migrations/20260811194045_blindar_qr_y_exigir_atestacion.sql",
    import.meta.url,
  ),
  "utf8",
);

test("token_hash no está incluido en ningún grant de catálogo autenticado", () => {
  const grantsTabla = [
    ...base.matchAll(
      /grant\s+select\s+on\s+table([\s\S]*?)to\s+authenticated\s*;/gi,
    ),
  ];
  assert.equal(
    grantsTabla.some((coincidencia) =>
      coincidencia[1].includes("public.puntos_rondin")
    ),
    false,
  );

  const grantColumnas = correctiva.match(
    /grant\s+select\s*\(([\s\S]*?)\)\s*on\s+public\.puntos_rondin\s+to\s+authenticated\s*;/i,
  );
  assert.ok(grantColumnas, "Falta el grant explícito de columnas seguras");
  assert.equal(grantColumnas[1].includes("token_hash"), false);
  assert.match(
    correctiva,
    /revoke\s+select\s*\(token_hash\)\s+on\s+table\s+public\.puntos_rondin/i,
  );
  assert.match(correctiva, /item\s*-\s*'token_hash'/i);
  assert.match(correctiva, /valor\s*->\s*'punto'[\s\S]*?-\s*'token_hash'/i);
});

test("la migración incremental impide validación automática sin atestación", () => {
  assert.match(correctiva, /DISPOSITIVO_NO_ATESTADO/);
  assert.match(
    correctiva,
    /if\s+new\.estado_validacion\s*=\s*'validado'\s+then[\s\S]*?new\.estado_validacion\s*:=\s*'pendiente_revision'/i,
  );
  assert.match(
    correctiva,
    /before\s+insert\s+on\s+public\.rondines[\s\S]*?forzar_revision_dispositivo_no_atestado/i,
  );
  assert.match(
    correctiva,
    /before\s+insert\s+on\s+public\.rondin_lecturas[\s\S]*?forzar_revision_dispositivo_no_atestado/i,
  );
  assert.match(
    correctiva,
    /update\s+public\.rondines[\s\S]*?'pendiente_revision'/i,
  );
  assert.match(
    correctiva,
    /update\s+public\.rondin_lecturas[\s\S]*?'pendiente_revision'/i,
  );
});

test("la migración base también nace con el guard de atestación", () => {
  assert.match(base, /DISPOSITIVO_NO_ATESTADO/);
  assert.match(base, /create\s+trigger\s+rondines_exigir_atestacion/i);
  assert.match(base, /create\s+trigger\s+rondin_lecturas_exigir_atestacion/i);
});

test("las revisiones son append-only, sólo visibles para admin y auditadas", () => {
  assert.match(correctiva, /create\s+table\s+if\s+not\s+exists\s+public\.rondin_revisiones/i);
  assert.match(
    correctiva,
    /decision\s+text\s+not\s+null\s+check\s*\(decision\s+in\s*\('aprobado',\s*'rechazado'\)\)/i,
  );
  assert.match(
    correctiva,
    /decision\s*=\s*'aprobado'\s+or\s+motivo\s*~\s*'\[\^\[:space:\]\]'/i,
  );
  assert.match(
    correctiva,
    /on\s+public\.rondin_revisiones\s*\(rondin_id,\s*created_at\s+desc,\s*id\s+desc\)/i,
  );
  assert.match(
    correctiva,
    /create\s+policy\s+rondin_revisiones_select_admin[\s\S]*?using\s*\(\(select\s+public\.es_admin\(\)\)\)/i,
  );
  assert.match(
    correctiva,
    /grant\s+select\s+on\s+table\s+public\.rondin_revisiones\s+to\s+authenticated/i,
  );
  assert.doesNotMatch(
    correctiva,
    /grant\s+(?:insert|update|delete|all)[\s\S]*?public\.rondin_revisiones[\s\S]*?to\s+authenticated/i,
  );
  assert.match(
    correctiva,
    /revoke\s+all\s+privileges\s+on\s+table\s+public\.rondin_revisiones\s+from\s+public,\s*anon,\s*authenticated,\s*service_role/i,
  );
  assert.doesNotMatch(
    correctiva,
    /grant\s+[^;]*(?:insert|update|delete|all)[^;]*public\.rondin_revisiones[^;]*to\s+service_role/i,
  );
  assert.match(
    base,
    /revoke\s+all\s+on\s+table\s+public\.rondin_revisiones\s+from\s+service_role/i,
  );
  assert.doesNotMatch(
    base,
    /grant\s+[^;]*(?:insert|update|delete|all)[^;]*public\.rondin_revisiones[^;]*to\s+service_role/i,
  );
  assert.match(
    correctiva,
    /before\s+update\s+or\s+delete\s+on\s+public\.rondin_revisiones[\s\S]*?bloquear_mutacion_rondin/i,
  );
  assert.match(correctiva, /when\s+p_accion\s*=\s*'revisar_rondin'/i);
  assert.match(correctiva, /'REVISAR_RONDIN'/);
  assert.match(
    correctiva,
    /jsonb_typeof\(p_datos\s*->\s*'decision'\)\s+is\s+distinct\s+from\s+'string'/i,
  );
  assert.match(
    correctiva,
    /jsonb_typeof\(p_datos\s*->\s*'motivo'\)\s+not\s+in\s*\('string',\s*'null'\)/i,
  );

  const auditoria = correctiva.match(
    /insert\s+into\s+public\.admin_rondin_auditoria[\s\S]*?'REVISAR_RONDIN'[\s\S]*?return\s+jsonb_build_object\('revision'/i,
  );
  assert.ok(auditoria, "Falta la auditoría de revisión");
  assert.equal(auditoria[0].includes("v_motivo"), false);
});
