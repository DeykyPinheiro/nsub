package com.nsub.bdd.steps;

import com.nsub.bdd.CucumberSpringConfig;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.Before;
import io.cucumber.java.pt.Dado;
import io.cucumber.java.pt.Quando;
import io.cucumber.java.pt.Então;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.test.context.ContextConfiguration;

import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

@ContextConfiguration(classes = CucumberSpringConfig.class)
public class UserRegistrationSteps {

    @LocalServerPort
    private int port;

    private Response response;
    private RequestSpecification request;

    private String baseUrl() {
        return "http://localhost:" + port;
    }

    @Before
    public void setup() {
        request = given()
                .contentType(ContentType.JSON)
                .accept(ContentType.JSON);
    }

    @Dado("que existe um usuário com email {string}")
    public void que_existe_um_usuario_com_email(String email) {
        // Pré-cadastra um usuário para testar duplicação
        String payload = String.format("""
                {
                  "username": "existing_user",
                  "email": "%s",
                  "password": "Senha@999",
                  "fullName": "Existing User"
                }
                """, email);

        given()
                .contentType(ContentType.JSON)
                .body(payload)
                .when()
                .post(baseUrl() + "/api/auth/register");
    }

    @Quando("eu envio uma requisição POST para {string} com o payload:")
    public void eu_envio_uma_requisicao_post_para_com_o_payload(String path, String payload) {
        response = request
                .body(payload)
                .when()
                .post(baseUrl() + path)
                .then()
                .extract()
                .response();
    }

    @Então("a resposta deve ter status {int}")
    public void a_resposta_deve_ter_status(Integer status) {
        response.then().statusCode(status);
    }

    @Então("o corpo da resposta deve conter:")
    public void o_corpo_da_resposta_deve_conter(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps();
        for (Map<String, String> row : rows) {
            String campo = row.get("campo");
            String valor = row.get("valor");
            response.then().body(campo, equalTo(valor));
        }
    }

    @Então("o campo {string} deve existir")
    public void o_campo_deve_existir(String campo) {
        response.then().body("$", hasKey(campo));
    }

    @Então("o corpo da resposta deve conter o campo {string} com valor {string}")
    public void o_corpo_da_resposta_deve_conter_o_campo_com_valor(String campo, String valor) {
        response.then().body(campo, equalTo(valor));
    }

    @Então("o corpo da resposta deve conter o campo {string}")
    public void o_corpo_da_resposta_deve_conter_o_campo(String campo) {
        response.then().body("$", hasKey(campo));
    }
}