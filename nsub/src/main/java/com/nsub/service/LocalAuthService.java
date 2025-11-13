package com.nsub.service;


import com.nsub.dto.RegisterRequest;
import com.nsub.dto.RegisterResponse;
import com.nsub.model.User;
import com.nsub.exception.DuplicateEmailException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.nsub.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class LocalAuthService {

    private final UserRepository userRepository;

    @Transactional
    public RegisterResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new DuplicateEmailException("Email já cadastrado");
        }

        if (userRepository.existsByUsername(request.getUsername())) {
            throw new DuplicateEmailException("Username já cadastrado");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        // TODO: Adicionar hash de senha (BCrypt) em produção
        user.setPassword(request.getPassword());
        user.setFullName(request.getFullName());

        User savedUser = userRepository.save(user);

        return new RegisterResponse("Usuário registrado com sucesso", savedUser.getId());
    }
}