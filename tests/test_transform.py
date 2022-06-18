from random import random, randint
from math import sin, cos

import pytest
import numpy as np
import termgl as tgl


def randarr(shape):
    return np.random.rand(*shape).astype(np.float32)


@pytest.fixture
def randm4():
    return randarr((4, 4))


@pytest.fixture
def randm3():
    return randarr((3, 3))


@pytest.fixture
def randnm3():
    return randarr((randint(10, 100), 3, 3))


@pytest.fixture
def randxyz():
    return (random(), random(), random())


@pytest.fixture
def randtransform():
    transform = tgl.Transform()
    transform.rotation = randarr((4, 4))
    transform.scale = randarr((4, 4))
    transform.translation = randarr((4, 4))
    transform.calc_result()
    return transform


def transform_apply(vert, mat):
    v4 = np.concatenate((vert, np.ones((1), dtype=np.float32)))
    res = mat.dot(v4)
    if res[3] != 0:
        res = res[:3] * (1.0 / res[3])
    return res


def rotation(x, y, z):
    return np.array([
            [cos(z) * cos(y),
             -sin(z) * cos(x) + cos(z) * sin(y) * sin(x),
             sin(z) * sin(x) + cos(z) * sin(y) * cos(x),
             0],
            [sin(z) * cos(y),
             cos(z) * cos(x) + sin(z) * sin(y) * sin(x),
             -cos(z) * sin(x) + sin(z) * sin(y) * cos(x),
             0],
            [-sin(y),
             cos(y) * sin(x),
             cos(y) * cos(x),
             0],
            [0,
             0,
             0,
             1],
    ], dtype=np.float32)


def scale(x, y, z):
    return np.array([
            [x, 0, 0, 0],
            [0, y, 0, 0],
            [0, 0, z, 0],
            [0, 0, 0, 1],
    ], dtype=np.float32)


def translation(x, y, z):
    return np.array([
        [1, 0, 0, x],
        [0, 1, 0, y],
        [0, 0, 1, z],
        [0, 0, 0, 1],
    ], dtype=np.float32)


def test_transform_new():
    transform = tgl.Transform()
    target = np.identity(4, dtype=np.float32)
    assert np.array_equal(transform.rotation, target)
    assert np.array_equal(transform.scale, target)
    assert np.array_equal(transform.translation, target)
    assert np.array_equal(transform.result, target)


def test_transform_set_rotation(randm4):
    transform = tgl.Transform()
    transform.rotation = randm4
    assert np.array_equal(transform.rotation, randm4)


def test_transform_set_scale(randm4):
    transform = tgl.Transform()
    transform.scale = randm4
    assert np.array_equal(transform.scale, randm4)


def test_transform_set_translation(randm4):
    transform = tgl.Transform()
    transform.translation = randm4
    assert np.array_equal(transform.translation, randm4)


def test_transform_calc_rotation(randxyz):
    transform = tgl.Transform()
    transform.calc_rotation(*randxyz)
    assert np.allclose(transform.rotation, rotation(*randxyz))


def test_transform_calc_scale(randxyz):
    transform = tgl.Transform()
    transform.calc_scale(*randxyz)
    assert np.allclose(transform.scale, scale(*randxyz))


def test_transform_calc_translate(randxyz):
    transform = tgl.Transform()
    transform.calc_translation(*randxyz)
    assert np.allclose(transform.translation, translation(*randxyz))


def test_transform_calc_result(randtransform):
    assert np.allclose(randtransform.result,
                       np.matmul(randtransform.translation,
                                 np.matmul(randtransform.scale,
                                           randtransform.rotation)))


def test_transform_apply(randtransform, randm3):
    result = np.empty((3, 3), dtype=np.float32)
    randtransform.apply(randm3, result)
    target = np.empty((3, 3), dtype=np.float32)
    for i in range(3):
        target[i] = transform_apply(randm3[i], randtransform.result)
    assert np.allclose(result, target)


def test_transform_applya(randtransform, randnm3):
    cnt = randnm3.shape[0]
    result = np.empty(randnm3.shape, dtype=np.float32)
    randtransform.applya(randnm3, result, cnt)
    target = np.empty(randnm3.shape, dtype=np.float32)
    for j in range(cnt):
        for i in range(3):
            target[j][i] = transform_apply(randnm3[j][i], randtransform.result)
    assert np.allclose(result, target)
